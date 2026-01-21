//
//  ProgressView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

struct ProgressView: View {
    @Environment(LearningViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Smooth gradient background
                AppColorTheme.smoothGradientBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Overall stats
                        overallStatsSection
                        
                        // Topic progress
                        topicProgressSection
                        
                        // Achievements
                        achievementsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(AppColorTheme.darkSurface.opacity(0.95), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .tint(AppColorTheme.exoticCyan)
        }
    }
    
    private var overallStatsSection: some View {
        VStack(spacing: 16) {
            Text("Overall Progress")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
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
            
            // Time spent
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
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
        )
    }
    
    private var topicProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Topic Progress")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            ForEach(viewModel.topics) { topic in
                TopicProgressCardView(topic: topic, progress: viewModel.getTopicProgress(for: topic.id))
            }
        }
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            if viewModel.userProgress.achievements.isEmpty {
                Text("Complete topics to unlock achievements!")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.05))
                    )
            } else {
                ForEach(viewModel.userProgress.achievements, id: \.self) { achievement in
                    AchievementCardView(achievementId: achievement)
                }
            }
        }
    }
    
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

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}

struct TopicProgressCardView: View {
    let topic: Topic
    let progress: TopicProgress?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(topic.title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                if topic.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            
            // Progress bar
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
            
            HStack {
                Text("\(Int(topic.progress * 100))% Complete")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                if let progress = progress, !progress.quizScores.isEmpty {
                    let avgScore = progress.quizScores.reduce(0, +) / Double(progress.quizScores.count)
                    Text("Avg Score: \(Int(avgScore * 100))%")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}

struct AchievementCardView: View {
    let achievementId: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 32))
                .foregroundColor(.yellow)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievementTitle)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(achievementDescription)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
    
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

#Preview {
    ProgressView()
        .environment(LearningViewModel())
}
