//
//  AchievementCardView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A card view that displays an achievement.
///
/// This view shows achievement information including icon, title,
/// and description for unlocked achievements.
struct AchievementCardView: View {
    /// The achievement identifier.
    let achievementId: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 32))
                .foregroundColor(.yellow)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievementTitle)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .primaryTextStyle()
                
                Text(achievementDescription)
                    .font(.system(size: 14, weight: .regular))
                    .secondaryTextStyle()
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
    
    // MARK: - Computed Properties
    
    private var achievementTitle: String {
        switch achievementId {
        case "first_complete": return "First Steps"
        case "all_complete": return "Master Swift"
        case "perfect_score": return "Perfect Score"
        default: return "Achievement"
        }
    }
    
    private var achievementDescription: String {
        switch achievementId {
        case "first_complete": return "Completed your first topic"
        case "all_complete": return "Completed all topics"
        case "perfect_score": return "Scored 100% on a quiz"
        default: return "Unlocked achievement"
        }
    }
}
