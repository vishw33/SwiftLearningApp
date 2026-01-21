//
//  CodeExampleCardView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A card view that displays a code example preview.
///
/// This view shows code example title and description in a card format
/// that can be tapped to view the full example.
struct CodeExampleCardView: View {
    /// The code example to display.
    let example: CodeExample
    
    /// Action to perform when the card is tapped.
    let action: () -> Void
    
    /// The color associated with the topic.
    let topicColor: Color
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Text(example.title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .primaryTextStyle()
                
                Text(example.description)
                    .font(.system(size: 14, weight: .regular))
                    .secondaryTextStyle()
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "chevron.right")
                        .foregroundColor(topicColor)
                        .shadow(color: topicColor.opacity(0.5), radius: 5, x: 0, y: 0)
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground)
            .overlay(cardBorder)
            .shadow(color: topicColor.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .cardButtonStyle()
        .padding(.horizontal)
    }
    
    // MARK: - Subviews
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 12)
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
                RoundedRectangle(cornerRadius: 12)
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
    
    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(
                LinearGradient(
                    colors: [topicColor.opacity(0.3), topicColor.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
    }
}
