//
//  TopicProgressCardView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A card view that displays progress for a specific topic.
///
/// This view shows topic title, completion status, progress bar,
/// and average quiz score if available.
struct TopicProgressCardView: View {
    /// The topic to display progress for.
    let topic: Topic
    
    /// The progress data for the topic.
    let progress: TopicProgress?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView
            progressBarView
            footerInfoView
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            Text(topic.title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .primaryTextStyle()
            
            Spacer()
            
            if topic.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
    }
    
    private var progressBarView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 8)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(topic.isCompleted ? Color.green : Color.blue)
                    .frame(width: geometry.size.width * topic.progress, height: 8)
                    .cornerRadius(4)
            }
        }
        .frame(height: 8)
    }
    
    private var footerInfoView: some View {
        HStack {
            Text("\(Int(topic.progress * 100))% Complete")
                .font(.system(size: 14, weight: .medium))
                .secondaryTextStyle()
            
            Spacer()
            
            if let progress = progress, !progress.quizScores.isEmpty {
                let avgScore = progress.quizScores.reduce(0, +) / Double(progress.quizScores.count)
                Text("Avg Score: \(Int(avgScore * 100))%")
                    .font(.system(size: 14, weight: .medium))
                    .secondaryTextStyle()
            }
        }
    }
}
