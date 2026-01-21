//
//  PageIndicatorView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A view that displays page indicators for paginated content.
///
/// This view shows animated dots representing pages and a page counter
/// for paginated topic displays.
struct PageIndicatorView: View {
    /// The total number of pages.
    let totalPages: Int
    
    /// The currently selected page index.
    @Binding var currentPageIndex: Int
    
    /// The topics array for color mapping.
    let topics: [Topic]
    
    var body: some View {
        VStack(spacing: 14) {
            animatedDots
            pageCounter
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal)
    }
    
    // MARK: - Subviews
    
    private var animatedDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                let topicColor = AppColorTheme.topicColor(for: topics[index].id)
                Capsule()
                    .fill(index == currentPageIndex ? topicColor : Color.white.opacity(0.3))
                    .frame(width: index == currentPageIndex ? 24 : 8, height: 8)
                    .animation(.interpolatingSpring(stiffness: 350, damping: 22), value: currentPageIndex)
                    .onTapGesture {
                        withAnimation(.interpolatingSpring(stiffness: 280, damping: 24)) {
                            currentPageIndex = index
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var pageCounter: some View {
        Text("\(currentPageIndex + 1) / \(totalPages)")
            .font(.system(size: 14, weight: .medium, design: .monospaced))
            .foregroundStyle(.white.opacity(0.5))
            .contentTransition(.numericText())
            .animation(.interpolatingSpring(stiffness: 300, damping: 25), value: currentPageIndex)
    }
}
