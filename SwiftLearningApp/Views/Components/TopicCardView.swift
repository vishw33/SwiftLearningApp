//
//  TopicCardView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A card view that displays topic information in a grid layout.
///
/// This view shows topic title, description, progress, and completion status
/// in a visually appealing card format suitable for grid layouts.
struct TopicCardView: View {
    /// The topic to display.
    let topic: Topic
    
    /// Action to perform when the card is tapped.
    let action: () -> Void
    
    private var topicColor: Color {
        AppColorTheme.topicColor(for: topic.id)
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                progressBarView
                
                VStack(alignment: .leading, spacing: 8) {
                    headerView
                    descriptionView
                    footerView
                }
            }
            .padding()
            .background(topicCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: topicColor.opacity(0.4), radius: 20, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [topicColor.opacity(0.5), topicColor.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
        }
        .cardButtonStyle()
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: topic.progress)
    }
    
    // MARK: - Subviews
    
    private var progressBarView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 4)
                    .cornerRadius(2)
                
                Group {
                    if topic.isCompleted {
                        AppColorTheme.successColor
                    } else {
                        LinearGradient(
                            colors: [topicColor, topicColor.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    }
                }
                .frame(width: geometry.size.width * topic.progress, height: 4)
                .cornerRadius(2)
            }
        }
        .frame(height: 4)
    }
    
    private var headerView: some View {
        HStack {
            Text(topic.title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .primaryTextStyle()
            
            Spacer()
            
            if topic.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(AppColorTheme.successColor)
                    .shadow(color: AppColorTheme.successColor.opacity(0.5), radius: 5, x: 0, y: 0)
            }
        }
    }
    
    private var descriptionView: some View {
        Text(topic.description)
            .font(.system(size: 14, weight: .regular))
            .secondaryTextStyle()
            .lineLimit(3)
    }
    
    private var footerView: some View {
        HStack {
            Text("\(Int(topic.progress * 100))% Complete")
                .font(.system(size: 12, weight: .medium))
                .tertiaryTextStyle()
            
            Spacer()
            
            Circle()
                .fill(topicColor)
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
        }
    }
    
    private var topicCardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    colors: [
                        Color(white: 0.15),
                        Color(white: 0.08)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                topicColor.opacity(0.1),
                                topicColor.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
    }
}
