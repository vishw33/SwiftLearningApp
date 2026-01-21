//
//  DifficultyBadgeView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A badge view that displays the difficulty level of a question.
///
/// This view shows a color-coded badge indicating the difficulty
/// level (easy, medium, hard, expert).
struct DifficultyBadgeView: View {
    /// The difficulty level to display.
    let difficulty: Difficulty
    
    var body: some View {
        Text(difficulty.rawValue.capitalized)
            .font(.system(size: 11, weight: .bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(difficultyColor.opacity(0.3))
            )
            .foregroundColor(difficultyColor)
    }
    
    private var difficultyColor: Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .yellow
        case .hard: return .orange
        case .expert: return .red
        }
    }
}
