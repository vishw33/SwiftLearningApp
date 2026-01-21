//
//  WebQuestion.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation

struct WebQuestion: Identifiable, Codable {
    let id: String
    let title: String
    let question: String
    let source: String // URL or source name
    let sourceType: String // "reddit", "stackoverflow", "swift-forums", etc.
    let difficulty: Difficulty
    let tags: [String]
    let solution: String?
    let codeSnippet: String?
    let fetchedDate: Date
    let upvotes: Int?
    
    init(
        id: String,
        title: String,
        question: String,
        source: String,
        sourceType: String,
        difficulty: Difficulty = .medium,
        tags: [String] = [],
        solution: String? = nil,
        codeSnippet: String? = nil,
        fetchedDate: Date = Date(),
        upvotes: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.question = question
        self.source = source
        self.sourceType = sourceType
        self.difficulty = difficulty
        self.tags = tags
        self.solution = solution
        self.codeSnippet = codeSnippet
        self.fetchedDate = fetchedDate
        self.upvotes = upvotes
    }
}
