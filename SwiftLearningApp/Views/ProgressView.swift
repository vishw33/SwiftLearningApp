//
//  ProgressView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// The main view that displays user learning progress.
///
/// This view shows overall statistics, topic progress, and achievements
/// to help users track their learning journey.
struct ProgressView: View {
    @Environment(LearningViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColorTheme.smoothGradientBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        overallStatsSection
                        topicProgressSection
                        achievementsSection
                    }
                    .padding()
                }
            }
            .standardNavigationBarStyle()
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Subviews
    
    private var overallStatsSection: some View {
        VStack(spacing: 16) {
            Text("Overall Progress")
                .titleStyle(size: 24)
            
            HStack(spacing: 32) {
                StatCardView(
                    title: "Topics Completed",
                    value: "\(viewModel.userProgress.totalTopicsCompleted)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                StatCardView(
                    title: "Total Topics",
                    value: "\(viewModel.topics.count)",
                    icon: "book.fill",
                    color: .blue
                )
            }
            
            timeSpentView
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
        )
    }
    
    private var timeSpentView: some View {
        HStack {
            Image(systemName: "clock.fill")
                .foregroundColor(.white.opacity(0.7))
            Text("Time Spent: \(formatTime(viewModel.userProgress.totalTimeSpent))")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
    
    private var topicProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Topic Progress")
                .titleStyle(size: 24)
            
            ForEach(viewModel.topics) { topic in
                TopicProgressCardView(topic: topic, progress: viewModel.getTopicProgress(for: topic.id))
            }
        }
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .titleStyle(size: 24)
            
            if viewModel.userProgress.achievements.isEmpty {
                emptyAchievementsView
            } else {
                ForEach(viewModel.userProgress.achievements, id: \.self) { achievement in
                    AchievementCardView(achievementId: achievement)
                }
            }
        }
    }
    
    private var emptyAchievementsView: some View {
        Text("Complete topics to unlock achievements!")
            .font(.system(size: 16, weight: .regular))
            .secondaryTextStyle()
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
            )
    }
    
    // MARK: - Helper Methods
    
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

#Preview {
    ProgressView()
        .environment(LearningViewModel())
}
