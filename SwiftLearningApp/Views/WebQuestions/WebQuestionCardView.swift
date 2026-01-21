//
//  WebQuestionCardView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A card view that displays a web question in a list.
///
/// This view shows question metadata including source, difficulty,
/// upvotes, and tags in a compact card format.
struct WebQuestionCardView: View {
    /// The web question to display.
    let question: WebQuestion
    
    /// Action to perform when the card is tapped.
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                headerMetadataView
                questionTitleView
                questionDescriptionView
                tagsView
                footerActionView
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: false)
            .cardStyle()
        }
        .cardButtonStyle()
    }
    
    // MARK: - Subviews
    
    private var headerMetadataView: some View {
        HStack {
            sourceBadgeView
            Spacer()
            DifficultyBadgeView(difficulty: question.difficulty)
            if let upvotes = question.upvotes {
                upvotesView(upvotes: upvotes)
            }
        }
    }
    
    private var sourceBadgeView: some View {
        HStack(spacing: 4) {
            Image(systemName: sourceIcon)
                .font(.system(size: 12))
            Text(question.sourceType.capitalized)
                .font(.system(size: 12, weight: .medium))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.blue.opacity(0.2))
        )
        .foregroundColor(.blue)
    }
    
    private func upvotesView(upvotes: Int) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "arrow.up.circle.fill")
            Text("\(upvotes)")
        }
        .font(.system(size: 12, weight: .medium))
        .foregroundColor(.orange)
    }
    
    private var questionTitleView: some View {
        Text(question.title)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .primaryTextStyle()
            .multilineTextAlignment(.leading)
    }
    
    private var questionDescriptionView: some View {
        Text(question.question)
            .font(.system(size: 16, weight: .regular))
            .secondaryTextStyle()
            .lineLimit(3)
            .multilineTextAlignment(.leading)
    }
    
    private var tagsView: some View {
        Group {
            if !question.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(question.tags.prefix(5), id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 12, weight: .medium))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.1))
                                )
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
            }
        }
    }
    
    private var footerActionView: some View {
        HStack {
            Spacer()
            Text("Tap to view solution")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.blue)
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.blue)
        }
    }
    
    private var sourceIcon: String {
        switch question.sourceType {
        case "reddit": return "globe"
        case "stackoverflow": return "questionmark.circle"
        case "swift-forums": return "message"
        default: return "link"
        }
    }
}
