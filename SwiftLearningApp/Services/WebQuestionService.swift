//
//  WebQuestionService.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation

/// A service that manages web-based questions from various sources.
///
/// This service provides access to curated tough questions sourced from
/// the Swift community (Reddit, Stack Overflow, Swift Forums). It handles
/// caching and retrieval of questions for the challenges feature.
@MainActor
class WebQuestionService {
    /// Shared singleton instance of the service.
    static let shared = WebQuestionService()
    
    private let cacheKey = "SwiftLearningApp.WebQuestions"
    private var cachedQuestions: [WebQuestion] = []
    
    private init() {
        loadCachedQuestions()
    }
    
    /// Fetches tough questions from the data source.
    ///
    /// In a real implementation, this would fetch from actual APIs.
    /// Currently returns curated questions from the data provider.
    ///
    /// - Returns: An array of `WebQuestion` instances.
    /// - Throws: An error if the fetch operation fails.
    func fetchToughQuestions() async throws -> [WebQuestion] {
        let questions = getCuratedToughQuestions()
        cachedQuestions = questions
        saveCachedQuestions(questions)
        return questions
    }
    
    /// Returns cached questions if available.
    ///
    /// - Returns: An array of cached `WebQuestion` instances.
    func getCachedQuestions() -> [WebQuestion] {
        return cachedQuestions
    }
    
    /// Loads cached questions from disk storage.
    ///
    /// This is a nonisolated static method that can be called
    /// from any context to retrieve cached questions.
    ///
    /// - Returns: An array of `WebQuestion` instances from disk cache.
    nonisolated static func loadCachedQuestionsFromDisk() -> [WebQuestion] {
        let cacheKey = "SwiftLearningApp.WebQuestions"
        if let data = UserDefaults.standard.data(forKey: cacheKey),
           let questions = try? JSONDecoder().decode([WebQuestion].self, from: data) {
            return questions
        }
        return []
    }
    
    private func loadCachedQuestions() {
        if let data = UserDefaults.standard.data(forKey: cacheKey),
           let questions = try? JSONDecoder().decode([WebQuestion].self, from: data) {
            cachedQuestions = questions
        }
    }
    
    private func saveCachedQuestions(_ questions: [WebQuestion]) {
        if let encoded = try? JSONEncoder().encode(questions) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
        }
    }
    
    /// Returns curated tough questions from the data provider.
    ///
    /// - Returns: An array of `WebQuestion` instances.
    private func getCuratedToughQuestions() -> [WebQuestion] {
        return WebQuestionData.getCuratedQuestions()
    }
}
