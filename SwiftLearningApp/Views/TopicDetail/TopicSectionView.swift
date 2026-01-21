//
//  TopicSectionView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A view that displays a section of topic content.
///
/// This view shows a topic section with title and content in a
/// styled card format with topic-specific color accents.
struct TopicSectionView: View {
    /// The section to display.
    let section: TopicSection
    
    /// The color associated with the topic.
    let topicColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title)
                .sectionHeaderStyle()
            
            Text(section.content)
                .font(.system(size: 16, weight: .regular))
                .secondaryTextStyle()
                .lineSpacing(4)
        }
        .padding()
        .background(sectionBackground)
        .overlay(sectionBorder)
        .shadow(color: topicColor.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
    
    // MARK: - Subviews
    
    private var sectionBackground: some View {
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
    
    private var sectionBorder: some View {
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
