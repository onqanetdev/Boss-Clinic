//
//  HTMLTextView.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 15/07/26.
//

import Foundation
import SwiftUI
import UIKit


struct HTMLTextView: UIViewRepresentable {

    let html: String

    final class Coordinator {
        var lastWidth: CGFloat = -1
        var lastHeight: CGFloat = -1
        var lastHTML: String = ""
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .black
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
        guard html != context.coordinator.lastHTML else { return }
        context.coordinator.lastHTML = html

        guard let data = html.data(using: .utf8) else {
            uiView.text = html
            return
        }

        do {
            let attributedString = try NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            attributedString.addAttributes([
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 16)
            ], range: NSRange(location: 0, length: attributedString.length))

            uiView.attributedText = attributedString
            // invalidate cached size since content changed
            context.coordinator.lastWidth = -1
        } catch {
            uiView.text = html
            uiView.textColor = .white
        }
    }

    func sizeThatFits(
        _ proposal: ProposedViewSize,
        uiView: UITextView,
        context: Context
    ) -> CGSize? {

        guard let width = proposal.width, width.isFinite, width > 0 else {
            return nil
        }

        // Return cached result if width hasn't meaningfully changed —
        // this breaks the re-entrant measurement loop.
        if abs(width - context.coordinator.lastWidth) < 0.5 {
            return CGSize(width: width, height: context.coordinator.lastHeight)
        }

        let fittingSize = uiView.sizeThatFits(
            CGSize(width: width, height: .greatestFiniteMagnitude)
        )

        context.coordinator.lastWidth = width
        context.coordinator.lastHeight = fittingSize.height

        return CGSize(width: width, height: fittingSize.height)
    }
}

