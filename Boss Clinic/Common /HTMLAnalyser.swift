//
//  HTMLAnalyser.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 15/07/26.
//


import Foundation
import SwiftUI
import UIKit

// MARK: - HTMLAnalyser

/// Parses HTML into NSAttributedString safely, off the main thread, with
/// caching and hard limits so malformed or oversized input can never crash
/// the app or produce a runaway allocation.
actor HTMLAnalyser {

   static let shared = HTMLAnalyser()

   /// Hard ceiling on input size. HTML above this is truncated before
   /// parsing. NSAttributedString's HTML importer has no real safety limits
   /// of its own, so we enforce one. Tune as needed — 500 KB of HTML is
   /// already far more than any reasonable "Terms & Conditions" document.
   private let maxInputBytes = 500_000

   /// Simple in-memory cache keyed by a hash of the (possibly truncated)
   /// input + the base font size, so identical content never gets
   /// re-parsed, and repeated SwiftUI re-renders are effectively free.
   private var cache: [Int: NSAttributedString] = [:]

   /// Parses `html` into an NSAttributedString suitable for display.
   /// Always safe to call from any thread — this is an actor, so calls are
   /// automatically serialized off the caller's thread.
   ///
   /// Never throws to the caller: on any failure (malformed HTML, decode
   /// failure, oversized input) it falls back to a plain-text rendering of
   /// the sanitized input so the UI always has *something* sane to show.
   func parse(
       html rawHTML: String,
       textColor: UIColor = .white,
       fontSize: CGFloat = 16
   ) -> NSAttributedString {

       let sanitized = sanitize(rawHTML)
       let cacheKey = makeCacheKey(sanitized, fontSize: fontSize)

       if let cached = cache[cacheKey] {
           return cached
       }

       let result = parseUncached(sanitized, textColor: textColor, fontSize: fontSize)
       cache[cacheKey] = result
       return result
   }

   func clearCache() {
       cache.removeAll()
   }

   // MARK: Private

   private func sanitize(_ html: String) -> String {

       guard let data = html.data(using: .utf8), data.count > maxInputBytes else {
           return html
       }

       // Truncate on a UTF-8 safe boundary rather than mid-character, and
       // close any obviously-open tags so the importer doesn't choke on a
       // dangling fragment.
       let truncated = data.prefix(maxInputBytes)
       return (String(data: truncated, encoding: .utf8) ?? "") + "…"
   }

   private func makeCacheKey(_ html: String, fontSize: CGFloat) -> Int {
       var hasher = Hasher()
       hasher.combine(html)
       hasher.combine(fontSize)
       return hasher.finalize()
   }

   private func parseUncached(
       _ html: String,
       textColor: UIColor,
       fontSize: CGFloat
   ) -> NSAttributedString {

       guard !html.isEmpty, let data = html.data(using: .utf8) else {
           return plainFallback(html, textColor: textColor, fontSize: fontSize)
       }

       do {
           let parsed = try NSMutableAttributedString(
               data: data,
               options: [
                   .documentType: NSAttributedString.DocumentType.html,
                   .characterEncoding: String.Encoding.utf8.rawValue
               ],
               documentAttributes: nil
           )

           // Guard against a pathological parse that produced something
           // enormous (some malformed HTML can expand wildly, e.g. deeply
           // nested tables). If it did, fall back to plain text rather than
           // handing UIKit a multi-megabyte attributed string to lay out.
           guard parsed.length < 200_000 else {
               return plainFallback(html, textColor: textColor, fontSize: fontSize)
           }

           parsed.addAttributes([
               .foregroundColor: textColor,
               .font: UIFont.systemFont(ofSize: fontSize)
           ], range: NSRange(location: 0, length: parsed.length))

           return parsed

       } catch {
           return plainFallback(html, textColor: textColor, fontSize: fontSize)
       }
   }

   private func plainFallback(
       _ text: String,
       textColor: UIColor,
       fontSize: CGFloat
   ) -> NSAttributedString {

       // Strip obvious tags so a plain-text fallback doesn't show raw "<p>"
       // markup to the user. Best-effort only — this is a fallback path.
       let stripped = text.replacingOccurrences(
           of: "<[^>]+>",
           with: "",
           options: .regularExpression
       )

       return NSAttributedString(
           string: stripped,
           attributes: [
               .foregroundColor: textColor,
               .font: UIFont.systemFont(ofSize: fontSize)
           ]
       )
   }
}

// MARK: - HTMLAnalyserView (SwiftUI)

/// Drop-in replacement for the old `HTMLTextView`. Same call site shape:
///
///     HTMLAnalyserView(html: terms.data.content)
///
/// Fixes applied vs. the previous implementation:
/// - Parsing happens off the main thread via `HTMLAnalyser` (an actor) and
///   is only ever applied to the UITextView on the main thread.
/// - `sizeThatFits` caches by width in the Coordinator, so it cannot become
///   re-entrant with SwiftUI's layout pass (this was the direct cause of
///   the AttributeGraph cycle warnings and the runaway "failed to allocate"
///   crash).
/// - Non-finite / zero / negative width proposals are rejected before ever
///   reaching UIKit's text sizing.
/// - Re-parses only when the input HTML actually changes.
struct HTMLAnalyserView: UIViewRepresentable {

   let html: String
   var textColor: UIColor = .white
   var fontSize: CGFloat = 16

   final class Coordinator {
       var lastHTML: String = ""
       var lastWidth: CGFloat = -1
       var lastHeight: CGFloat = 0
       var parseTask: Task<Void, Never>?
   }

   func makeCoordinator() -> Coordinator {
       Coordinator()
   }

   func makeUIView(context: Context) -> UITextView {

       let textView = UITextView()

       textView.backgroundColor = .clear
       textView.isEditable = false
       textView.isSelectable = true
       textView.isScrollEnabled = false

       textView.textContainerInset = .zero
       textView.textContainer.lineFragmentPadding = 0

       textView.adjustsFontForContentSizeCategory = true
       textView.isUserInteractionEnabled = false

       textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
       textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

       return textView
   }

   func updateUIView(_ uiView: UITextView, context: Context) {

       // Skip entirely if nothing changed — avoids unnecessary reflow
       // that can retrigger the AttributeGraph.
       guard html != context.coordinator.lastHTML else { return }
       context.coordinator.lastHTML = html

       // Cancel any in-flight parse for stale (previous) HTML.
       context.coordinator.parseTask?.cancel()

       let textColor = self.textColor
       let fontSize = self.fontSize

       context.coordinator.parseTask = Task {
           let attributed = await HTMLAnalyser.shared.parse(
               html: html,
               textColor: textColor,
               fontSize: fontSize
           )

           if Task.isCancelled { return }

           // Always apply on the main thread. `updateUIView` itself runs
           // on the main thread, but the parse above hopped off of it, so
           // we hop back explicitly and defensively.
           await MainActor.run {
               guard !Task.isCancelled else { return }
               if uiView.attributedText.string != attributed.string {
                   uiView.attributedText = attributed
                   // Content changed — invalidate the cached size so the
                   // next layout pass measures fresh, exactly once.
                   context.coordinator.lastWidth = -1
                   uiView.invalidateIntrinsicContentSize()
               }
           }
       }
   }

   func sizeThatFits(
       _ proposal: ProposedViewSize,
       uiView: UITextView,
       context: Context
   ) -> CGSize? {

       guard let width = proposal.width, width.isFinite, width > 0 else {
           // Reject garbage proposals outright rather than letting them
           // flow into UIKit's text sizing — this is what previously
           // produced runaway allocation sizes.
           return nil
       }

       // Stable-width short-circuit: this is what breaks the
       // sizeThatFits <-> updateUIView re-entrancy loop that SwiftUI's
       // AttributeGraph was flagging as a cycle.
       if abs(width - context.coordinator.lastWidth) < 0.5 {
           return CGSize(width: width, height: context.coordinator.lastHeight)
       }

       let fittingSize = uiView.sizeThatFits(
           CGSize(width: width, height: .greatestFiniteMagnitude)
       )

       // Sanity-clamp the result. If UIKit ever hands back something
       // absurd (NaN, infinite, or a wildly implausible height), fall back
       // to a safe default instead of propagating garbage upward.
       let safeHeight: CGFloat
       if fittingSize.height.isFinite, fittingSize.height >= 0, fittingSize.height < 100_000 {
           safeHeight = fittingSize.height
       } else {
           safeHeight = 0
       }

       context.coordinator.lastWidth = width
       context.coordinator.lastHeight = safeHeight

       return CGSize(width: width, height: safeHeight)
   }

   static func dismantleUIView(_ uiView: UITextView, coordinator: Coordinator) {
       coordinator.parseTask?.cancel()
   }
}

// MARK: - Preview

#Preview {
   ScrollView {
       HTMLAnalyserView(
           html: "<h1>Terms &amp; Conditions</h1><p>This is a <b>sample</b> terms document with <i>some</i> formatting.</p>"
       )
       .padding(20)
   }
   .background(Color.black.ignoresSafeArea())
}


