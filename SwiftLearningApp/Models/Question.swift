//
//  Question.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation

enum QuestionType: String, Codable {
    case multipleChoice
    case trueFalse
    case codeCompletion
    case bugIdentification
    case migrationScenario
}

enum Difficulty: String, Codable {
    case easy
    case medium
    case hard
    case expert
}

struct Question: Identifiable, Codable {
    let id: String
    let topicId: String
    let type: QuestionType
    let question: String
    let options: [String]?
    let correctAnswer: String
    let explanation: String
    let difficulty: Difficulty
    let codeSnippet: String?
    let source: String? // For web-sourced questions
    
    init(
        id: String,
        topicId: String,
        type: QuestionType,
        question: String,
        options: [String]? = nil,
        correctAnswer: String,
        explanation: String,
        difficulty: Difficulty = .medium,
        codeSnippet: String? = nil,
        source: String? = nil
    ) {
        self.id = id
        self.topicId = topicId
        self.type = type
        self.question = question
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
        self.difficulty = difficulty
        self.codeSnippet = codeSnippet
        self.source = source
    }
}
