//
//  CardModifiers.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A view modifier that applies a card style with optional glow effect.
///
/// This modifier creates a card appearance with gradient background,
/// border, and shadow effects. The glow effect can be enabled for
/// emphasis on important cards.
///
/// - Parameter hasGlow: Whether to apply an enhanced glow effect to the card.
///
/// ## Example
/// ```swift
/// Text("Card Content")
///     .cardStyle(hasGlow: true)
/// ```
struct CardStyle: ViewModifier {
    /// Whether to apply an enhanced glow effect
    let hasGlow: Bool
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    if #available(iOS 18.0, macOS 15.0, *) {
                        AppColorTheme.meshGradientCard
                    } else {
                        AppColorTheme.fallbackGradientCard
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            hasGlow ? AppColorTheme.exoticCyan.opacity(0.4) : AppColorTheme.exoticCyan.opacity(0.3),
                            lineWidth: hasGlow ? 2 : 1.5
                        )
                )
            )
            .shadow(
                color: hasGlow ? AppColorTheme.exoticPurple.opacity(0.3) : .black.opacity(0.3),
                radius: hasGlow ? 15 : 10,
                x: 0,
                y: hasGlow ? 8 : 5
            )
    }
}

/// A view modifier that applies an elevated card style with subtle background.
///
/// This modifier creates a subtle elevated appearance suitable for
/// content sections that need visual separation without strong emphasis.
///
/// ## Example
/// ```swift
/// VStack {
///     Text("Content")
/// }
/// .elevatedCardStyle()
/// ```
struct ElevatedCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColorTheme.exoticPurple.opacity(0.2), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.4), radius: 15, x: 0, y: 8)
    }
}

extension View {
    /// Applies a card style with optional glow effect.
    ///
    /// - Parameter hasGlow: Whether to apply an enhanced glow effect. Defaults to `false`.
    /// - Returns: A view with card styling applied.
    func cardStyle(hasGlow: Bool = false) -> some View {
        modifier(CardStyle(hasGlow: hasGlow))
    }
    
    /// Applies an elevated card style with subtle background.
    ///
    /// - Returns: A view with elevated card styling applied.
    func elevatedCardStyle() -> some View {
        modifier(ElevatedCardStyle())
    }
}
