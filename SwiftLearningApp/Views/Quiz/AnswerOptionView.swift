//
//  AnswerOptionView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A view that displays a single answer option for a quiz question.
///
/// This view shows an answer option with visual feedback when selected,
/// including animations and styling changes.
struct AnswerOptionView: View {
    /// The answer option text to display.
    let option: String
    
    /// Whether this option is currently selected.
    let isSelected: Bool
    
    /// Action to perform when the option is tapped.
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(option)
                    .font(.system(size: 16, weight: .regular))
                    .primaryTextStyle()
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppColorTheme.exoticCyan)
                        .shadow(color: AppColorTheme.exoticCyan.opacity(0.5), radius: 5, x: 0, y: 0)
                }
            }
            .padding()
            .background(optionBackground)
            .shadow(
                color: isSelected ? AppColorTheme.exoticPurple.opacity(0.3) : .black.opacity(0.2),
                radius: isSelected ? 10 : 5,
                x: 0,
                y: isSelected ? 5 : 2
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .cardButtonStyle()
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isSelected)
    }
    
    private var optionBackground: some View {
        Group {
            if isSelected {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColorTheme.exoticPurple.opacity(0.4),
                                AppColorTheme.exoticCyan.opacity(0.4)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColorTheme.exoticCyan, lineWidth: 2)
                    )
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColorTheme.exoticCyan.opacity(0.3), lineWidth: 1.5)
                    )
            }
        }
    }
}
