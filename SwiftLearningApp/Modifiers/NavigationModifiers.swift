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
            #if os(iOS)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(AppColorTheme.darkSurface.opacity(0.95), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            #endif
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
    
    /// Applies inline navigation bar title display mode on iOS.
    ///
    /// This modifier is a no-op on macOS where this API is not available.
    ///
    /// - Returns: A view with inline title display mode on iOS.
    func inlineNavigationBarTitle() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
    
    /// Applies large navigation bar title display mode on iOS.
    ///
    /// This modifier is a no-op on macOS where this API is not available.
    ///
    /// - Returns: A view with large title display mode on iOS.
    func largeNavigationBarTitle() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.large)
        #else
        self
        #endif
    }
}
