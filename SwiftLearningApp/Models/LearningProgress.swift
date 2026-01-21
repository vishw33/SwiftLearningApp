//
//  LearningProgress.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation

struct TopicProgress: Codable {
    let topicId: String
    var isCompleted: Bool
    var progress: Double
    var quizScores: [Double] // Historical scores
    var lastAttemptDate: Date?
    var timeSpent: TimeInterval // in seconds
    
    init(
        topicId: String,
        isCompleted: Bool = false,
        progress: Double = 0.0,
        quizScores: [Double] = [],
        lastAttemptDate: Date? = nil,
        timeSpent: TimeInterval = 0
    ) {
        self.topicId = topicId
        self.isCompleted = isCompleted
        self.progress = progress
        self.quizScores = quizScores
        self.lastAttemptDate = lastAttemptDate
        self.timeSpent = timeSpent
    }
}

@Observable
@MainActor
final class LearningProgress {
    var topicProgress: [String: TopicProgress]
    var totalTopicsCompleted: Int
    var totalTimeSpent: TimeInterval
    var achievements: [String] // Achievement IDs
    
    init(
        topicProgress: [String: TopicProgress] = [:],
        totalTopicsCompleted: Int = 0,
        totalTimeSpent: TimeInterval = 0,
        achievements: [String] = []
    ) {
        self.topicProgress = topicProgress
        self.totalTopicsCompleted = totalTopicsCompleted
        self.totalTimeSpent = totalTimeSpent
        self.achievements = achievements
    }
    
    func updateProgress(for topicId: String, progress: Double, isCompleted: Bool = false) {
        if var existing = topicProgress[topicId] {
            existing.progress = progress
            existing.isCompleted = isCompleted
            existing.lastAttemptDate = Date()
            topicProgress[topicId] = existing
        } else {
            topicProgress[topicId] = TopicProgress(
                topicId: topicId,
                isCompleted: isCompleted,
                progress: progress,
                lastAttemptDate: Date()
            )
        }
        
        if isCompleted {
            totalTopicsCompleted = topicProgress.values.filter { $0.isCompleted }.count
        }
    }
    
    func addQuizScore(for topicId: String, score: Double) {
        if var existing = topicProgress[topicId] {
            existing.quizScores.append(score)
            topicProgress[topicId] = existing
        } else {
            var newProgress = TopicProgress(topicId: topicId)
            newProgress.quizScores.append(score)
            topicProgress[topicId] = newProgress
        }
    }
    
    func addTimeSpent(for topicId: String, time: TimeInterval) {
        if var existing = topicProgress[topicId] {
            existing.timeSpent += time
            topicProgress[topicId] = existing
        } else {
            topicProgress[topicId] = TopicProgress(topicId: topicId, timeSpent: time)
        }
        totalTimeSpent += time
    }
}

extension LearningProgress: Codable {
    enum CodingKeys: String, CodingKey {
        case topicProgress, totalTopicsCompleted, totalTimeSpent, achievements
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let topicProgress = try container.decode([String: TopicProgress].self, forKey: .topicProgress)
        let totalTopicsCompleted = try container.decode(Int.self, forKey: .totalTopicsCompleted)
        let totalTimeSpent = try container.decode(TimeInterval.self, forKey: .totalTimeSpent)
        let achievements = try container.decodeIfPresent([String].self, forKey: .achievements) ?? []
        self.init(
            topicProgress: topicProgress,
            totalTopicsCompleted: totalTopicsCompleted,
            totalTimeSpent: totalTimeSpent,
            achievements: achievements
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(topicProgress, forKey: .topicProgress)
        try container.encode(totalTopicsCompleted, forKey: .totalTopicsCompleted)
        try container.encode(totalTimeSpent, forKey: .totalTimeSpent)
        try container.encode(achievements, forKey: .achievements)
    }
}
