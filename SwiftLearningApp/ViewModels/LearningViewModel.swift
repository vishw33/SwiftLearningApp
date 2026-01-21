//
//  LearningViewModel.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation
import SwiftUI
import Observation

/// The main view model for managing learning content and progress.
///
/// This observable class manages the state of topics, user progress,
/// and coordinates between content and progress services. It provides
/// methods to load topics, track progress, and complete quizzes.
///
/// ## Topics
/// The view model loads topics from JSON files and syncs them with
/// stored progress data to show completion status and progress bars.
///
/// ## Progress Tracking
/// Progress is automatically saved when quizzes are completed, and
/// topics are marked as completed when quiz scores reach 70% or higher.
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
    
    /// Loads all available topics from the content service.
    ///
    /// This method fetches topics from JSON files and syncs them with
    /// stored progress data. Progress information is applied to each
    /// topic to show completion status and progress percentages.
    ///
    /// - Note: This method sets `isLoading` to `true` during the operation
    ///   and updates `errorMessage` if loading fails.
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
    
    /// Sets the currently active topic.
    ///
    /// - Parameter topic: The topic to set as the current topic.
    func startTopic(_ topic: Topic) {
        currentTopic = topic
    }
    
    /// Records quiz completion and updates topic progress.
    ///
    /// This method updates the user's progress for a topic based on
    /// the quiz score. Topics are marked as completed if the score
    /// is 70% or higher.
    ///
    /// - Parameters:
    ///   - score: The quiz score as a value between 0.0 and 1.0.
    ///   - topicId: The identifier of the topic that was quizzed.
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
    
    /// Retrieves progress information for a specific topic.
    ///
    /// - Parameter topicId: The identifier of the topic.
    /// - Returns: The topic progress if available, otherwise `nil`.
    func getTopicProgress(for topicId: String) -> TopicProgress? {
        return userProgress.topicProgress[topicId]
    }
}
