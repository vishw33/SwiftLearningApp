//
//  ButtonModifiers.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

extension View {
    /// Applies a primary button style with gradient background.
    ///
    /// - Parameters:
    ///   - color: The primary color for the button gradient.
    ///   - cornerRadius: Corner radius for the button. Defaults to 12.
    /// - Returns: A view with primary button styling applied.
    ///
    /// ## Example
    /// ```swift
    /// Button("Action") { }
    ///     .primaryButtonStyle(color: .blue)
    /// ```
    func primaryButtonStyle(color: Color, cornerRadius: CGFloat = 12) -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [color, color.opacity(0.7)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color.opacity(0.6), lineWidth: 2)
            )
            .shadow(color: color.opacity(0.5), radius: 20, x: 0, y: 8)
    }
    
    /// Applies a card button style that removes default button appearance.
    ///
    /// - Returns: A view with card button styling applied.
    func cardButtonStyle() -> some View {
        self
            .buttonStyle(PlainButtonStyle())
    }
}
