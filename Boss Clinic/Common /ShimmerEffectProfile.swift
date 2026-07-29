//
//  ShimmerEffectProfile.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 28/07/26.
//

import SwiftUI

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.25),
                            Color.white.opacity(0)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 1.5)
                    .offset(x: phase * geo.size.width * 2 - geo.size.width * 0.5)
                }
            )
            .clipped()
            .onAppear {
                withAnimation(
                    .linear(duration: 1.4)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        self.modifier(ShimmerEffect())
    }
}

// Reusable skeleton block — a rounded rectangle filled with dark gray,
// shimmering, matching your field/label shapes
struct SkeletonBlock: View {
    var height: CGFloat
    var cornerRadius: CGFloat = 16
    var width: CGFloat? = nil

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.white.opacity(0.08))
            .frame(width: width, height: height)
            .shimmering()
    }
}


