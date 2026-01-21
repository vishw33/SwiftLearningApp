//
//  ContentService.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation

actor ContentService {
    static let shared = ContentService()
    
    private init() {}
    
    func loadTopics() async throws -> [Topic] {
        let topicFiles = [
            "swiftBasics",
            "accessSpecifiers",
            "dynamicLibrary",
            "staticLibrary",
            "closures",
            "memoryManagement",
            "dispatchQueue",
            "threading",
            "serialConcurrentSyncAsync",
            "avkit",
            "observableObservableObject",
            "asyncAwait",
            "swift6Migration",
            "commonMistakes",
            "concurrency"
        ]
        
        var topics: [Topic] = []
        var errors: [String] = []
        
        for topicFile in topicFiles {
            do {
                if let topic = try await loadTopic(from: topicFile) {
                    topics.append(topic)
                } else {
                    errors.append("\(topicFile).json: returned nil")
                }
            } catch {
                errors.append("\(topicFile).json: \(error.localizedDescription)")
            }
        }
        
        if topics.isEmpty && !errors.isEmpty {
            throw ContentServiceError.decodingError("Failed to load any topics. Errors: \(errors.joined(separator: "; "))")
        }
        
        return topics
    }
    
    func loadTopic(from filename: String) async throws -> Topic? {
        // Try multiple possible paths for the JSON file
        let subdirectories = ["Resources/Topics", "Topics", "Resources", ""]
        
        guard let fileURL = BundleHelper.findJSONFile(name: filename, in: subdirectories) else {
            // Debug: List all available JSON files
            let availableFiles = BundleHelper.listJSONFiles()
            print("DEBUG: Could not find \(filename).json")
            print("DEBUG: Available JSON files in bundle: \(availableFiles)")
            throw ContentServiceError.fileNotFound("\(filename).json (tried multiple paths). Available files: \(availableFiles.joined(separator: ", "))")
        }
        
        print("✅ Found \(filename).json at: \(fileURL.path)")
        
        let data = try Data(contentsOf: fileURL)
        // Decode off the actor, then create on MainActor
        let topic = try await MainActor.run {
            try JSONDecoder().decode(Topic.self, from: data)
        }
        return topic
    }
    
    func loadQuestions(for topicId: String) async throws -> [Question] {
        let subdirectories = ["Resources/Questions", "Questions", "Resources", ""]
        
        guard let fileURL = BundleHelper.findJSONFile(name: "quizQuestions", in: subdirectories) else {
            throw ContentServiceError.fileNotFound("quizQuestions.json")
        }
        
        let data = try Data(contentsOf: fileURL)
        let allQuestions = try JSONDecoder().decode([Question].self, from: data)
        
        return allQuestions.filter { $0.topicId == topicId }
    }
    
    func loadCodeExamples(for topicId: String) async throws -> [CodeExample] {
        let subdirectories = ["Resources", ""]
        
        guard let fileURL = BundleHelper.findJSONFile(name: "codeExamples", in: subdirectories) else {
            throw ContentServiceError.fileNotFound("codeExamples.json")
        }
        
        let data = try Data(contentsOf: fileURL)
        let allExamples = try JSONDecoder().decode([CodeExample].self, from: data)
        
        return allExamples.filter { $0.relatedTopicId == topicId }
    }
    
    func getAllQuestions() async throws -> [Question] {
        guard let url = Bundle.main.url(
            forResource: "quizQuestions",
            withExtension: "json",
            subdirectory: "Resources/Questions"
        ) else {
            throw ContentServiceError.fileNotFound("quizQuestions.json")
        }
        
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([Question].self, from: data)
    }
    
    func getAllCodeExamples() async throws -> [CodeExample] {
        guard let url = Bundle.main.url(
            forResource: "codeExamples",
            withExtension: "json",
            subdirectory: "Resources"
        ) else {
            throw ContentServiceError.fileNotFound("codeExamples.json")
        }
        
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([CodeExample].self, from: data)
    }
}

enum ContentServiceError: LocalizedError {
    case fileNotFound(String)
    case decodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let filename):
            return "Could not find resource file: \(filename)"
        case .decodingError(let message):
            return "Failed to decode content: \(message)"
        }
    }
}
