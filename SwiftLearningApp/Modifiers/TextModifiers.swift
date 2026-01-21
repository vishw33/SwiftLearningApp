//
//  TextModifiers.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

extension View {
    /// Applies primary text styling with shadow effect.
    ///
    /// - Parameter shadowColor: Optional color for the shadow effect.
    /// - Returns: A view with primary text styling applied.
    func primaryTextStyle(shadowColor: Color? = nil) -> some View {
        self
            .foregroundColor(AppColorTheme.primaryText)
            .shadow(
                color: shadowColor?.opacity(0.5) ?? AppColorTheme.exoticPurple.opacity(0.5),
                radius: 10,
                x: 0,
                y: 0
            )
    }
    
    /// Applies secondary text styling.
    ///
    /// - Returns: A view with secondary text styling applied.
    func secondaryTextStyle() -> some View {
        self
            .foregroundColor(AppColorTheme.secondaryText)
    }
    
    /// Applies tertiary text styling.
    ///
    /// - Returns: A view with tertiary text styling applied.
    func tertiaryTextStyle() -> some View {
        self
            .foregroundColor(AppColorTheme.tertiaryText)
    }
    
    /// Applies a title style with rounded font design.
    ///
    /// - Parameters:
    ///   - size: Font size. Defaults to 24.
    ///   - weight: Font weight. Defaults to .bold.
    /// - Returns: A view with title styling applied.
    func titleStyle(size: CGFloat = 24, weight: Font.Weight = .bold) -> some View {
        self
            .font(.system(size: size, weight: weight, design: .rounded))
            .foregroundColor(AppColorTheme.primaryText)
    }
    
    /// Applies a section header style.
    ///
    /// - Returns: A view with section header styling applied.
    func sectionHeaderStyle() -> some View {
        self
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .foregroundColor(AppColorTheme.primaryText)
    }
}
