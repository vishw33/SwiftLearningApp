//
//  LearningViewModel.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation
import SwiftUI
import Observation

@Observable
@MainActor
class LearningViewModel {
    var topics: [Topic] = []
    var currentTopic: Topic?
    var selectedQuestion: Question?
    var userProgress: LearningProgress
    var isLoading: Bool = false
    var errorMessage: String?
    
    private let contentService: ContentService
    private let progressService: ProgressService
    
    init(
        contentService: ContentService = ContentService.shared,
        progressService: ProgressService = ProgressService.shared
    ) {
        self.contentService = contentService
        self.progressService = progressService
        self.userProgress = ProgressService.shared.loadProgress()
    }
    
    func loadTopics() async {
        isLoading = true
        errorMessage = nil
        
        do {
            topics = try await contentService.loadTopics()
            // Sync progress with loaded topics
            for topic in topics {
                if let progress = userProgress.topicProgress[topic.id] {
                    topic.progress = progress.progress
                    topic.isCompleted = progress.isCompleted
                }
            }
            print("✅ Loaded \(topics.count) topics successfully")
        } catch {
            let errorMsg = "Failed to load topics: \(error.localizedDescription)"
            errorMessage = errorMsg
            print("❌ Error loading topics: \(errorMsg)")
            print("Error details: \(error)")
        }
        
        isLoading = false
    }
    
    func startTopic(_ topic: Topic) {
        currentTopic = topic
    }
    
    func completeQuiz(score: Double, topicId: String) {
        let isCompleted = score >= 0.7 // 70% threshold
        let progress = score
        
        userProgress.updateProgress(
            for: topicId,
            progress: progress,
            isCompleted: isCompleted
        )
        userProgress.addQuizScore(for: topicId, score: score)
        
        // Update topic in list
        if let index = topics.firstIndex(where: { $0.id == topicId }) {
            topics[index].progress = progress
            topics[index].isCompleted = isCompleted
        }
        
        // Save progress
        ProgressService.shared.saveProgress(userProgress)
    }
    
    func getTopicProgress(for topicId: String) -> TopicProgress? {
        return userProgress.topicProgress[topicId]
    }
}
