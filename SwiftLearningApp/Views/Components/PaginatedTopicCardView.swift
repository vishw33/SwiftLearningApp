//
//  PaginatedTopicCardView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A card view designed for paginated topic display.
///
/// This view presents topic information in a paginated carousel format
/// with a large color swatch section and content section below.
struct PaginatedTopicCardView: View {
    /// The topic to display.
    let topic: Topic
    
    /// Action to perform when the card is tapped.
    let action: () -> Void
    
    private let cornerRadius: CGFloat = 28
    private var topicColor: Color {
        AppColorTheme.topicColor(for: topic.id)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let colorSwatchHeight = geometry.size.height * 0.52
            
            VStack(alignment: .leading, spacing: 0) {
                colorSwatchSection(height: colorSwatchHeight)
                contentSection
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(color: topicColor.opacity(0.4), radius: 20, x: 0, y: 10)
        .onTapGesture { action() }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private func colorSwatchSection(height: CGFloat) -> some View {
        ZStack {
            topicColor
            
            LinearGradient(
                colors: [.white.opacity(0.2), .clear, .black.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            decorativeCircles
            
            topicIconOverlay
        }
        .frame(height: height)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: cornerRadius,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: cornerRadius
            )
        )
    }
    
    private var decorativeCircles: some View {
        GeometryReader { geo in
            Group {
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: geo.size.width * 0.4, height: geo.size.width * 0.4)
                    .offset(x: -geo.size.width * 0.2, y: -geo.size.height * 0.15)
                
                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: geo.size.width * 0.25, height: geo.size.width * 0.25)
                    .offset(x: geo.size.width * 0.6, y: geo.size.height * 0.5)
            }
        }
    }
    
    private var topicIconOverlay: some View {
        GeometryReader { geo in
            Image(systemName: AppColorTheme.topicIcon(for: topic.id))
                .font(.system(size: min(geo.size.width, geo.size.height) * 0.35, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.9),
                            .white.opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(topic.description)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            footerContent
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var footerContent: some View {
        HStack(spacing: 8) {
            Text("Explore")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(topicColor)
            
            Image(systemName: "arrow.right.circle.fill")
                .font(.system(size: 18))
                .foregroundStyle(topicColor)
            
            Spacer(minLength: 8)
            
            circularProgressView
        }
        .frame(maxWidth: .infinity)
    }
    
    private var circularProgressView: some View {
        ZStack {
            Circle()
                .stroke(topicColor.opacity(0.3), lineWidth: 3)
                .frame(width: 40, height: 40)
            
            Circle()
                .trim(from: 0, to: topic.progress)
                .stroke(
                    topicColor,
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: topic.progress)
            
            Text("\(Int(topic.progress * 100))%")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundStyle(topicColor)
        }
        .overlay(
            Circle()
                .stroke(.white.opacity(0.3), lineWidth: 2)
                .frame(width: 40, height: 40)
        )
    }
    
    @ViewBuilder
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(
                LinearGradient(
                    colors: [Color(white: 0.15), Color(white: 0.08)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}
