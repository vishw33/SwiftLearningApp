//
//  NavigationModifiers.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

extension View {
    /// Applies standard navigation bar styling for the app.
    ///
    /// This modifier configures the navigation bar with dark theme,
    /// custom background, and accent color consistent with the app's design.
    ///
    /// - Returns: A view with navigation bar styling applied.
    ///
    /// ## Example
    /// ```swift
    /// NavigationStack {
    ///     ContentView()
    ///         .standardNavigationBarStyle()
    /// }
    /// ```
    func standardNavigationBarStyle() -> some View {
        self
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(AppColorTheme.darkSurface.opacity(0.95), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .tint(AppColorTheme.exoticCyan)
    }
    
    /// Applies standard background gradient to the view.
    ///
    /// This modifier applies the app's standard gradient background
    /// that extends to all safe areas.
    ///
    /// - Returns: A view with standard background applied.
    ///
    /// ## Example
    /// ```swift
    /// VStack {
    ///     Text("Content")
    /// }
    /// .standardBackground()
    /// ```
    func standardBackground() -> some View {
        self
            .background(
                AppColorTheme.smoothGradientBackground
                    .ignoresSafeArea()
            )
    }
}
