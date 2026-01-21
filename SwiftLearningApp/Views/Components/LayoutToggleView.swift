//
//  LayoutToggleView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A toggle view for switching between grid and paginated layouts.
///
/// This view provides a user interface for switching between different
/// display modes for topic lists.
struct LayoutToggleView: View {
    /// Whether the paginated layout is currently active.
    @Binding var isPaginatedLayout: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            Text("Layout")
                .font(.system(size: 14, weight: .medium))
                .tertiaryTextStyle()
            
            Spacer()
            
            HStack(spacing: 8) {
                gridLayoutButton
                paginatedLayoutButton
            }
        }
        .padding(.horizontal)
        .frame(width: 350)
    }
    
    // MARK: - Subviews
    
    private var gridLayoutButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPaginatedLayout = false
            }
        }) {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isPaginatedLayout ? AppColorTheme.tertiaryText : AppColorTheme.exoticCyan)
                .frame(width: 40, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isPaginatedLayout ? Color.clear : AppColorTheme.exoticCyan.opacity(0.2))
                )
        }
    }
    
    private var paginatedLayoutButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPaginatedLayout = true
            }
        }) {
            Image(systemName: "rectangle.stack")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isPaginatedLayout ? AppColorTheme.exoticCyan : AppColorTheme.tertiaryText)
                .frame(width: 40, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isPaginatedLayout ? AppColorTheme.exoticCyan.opacity(0.2) : Color.clear)
                )
        }
    }
}
