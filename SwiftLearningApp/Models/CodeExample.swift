//
//  CodeExample.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation

struct CodeAnnotation: Identifiable, Codable {
    let id: String
    let lineNumber: Int
    let text: String
    let highlight: Bool
}

struct CodeExample: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let code: String
    let language: String
    let beforeCode: String? // For migration examples
    let afterCode: String? // For migration examples
    let annotations: [CodeAnnotation]
    let relatedTopicId: String
    let isMigrationExample: Bool
    
    init(
        id: String,
        title: String,
        description: String,
        code: String,
        language: String = "swift",
        beforeCode: String? = nil,
        afterCode: String? = nil,
        annotations: [CodeAnnotation] = [],
        relatedTopicId: String,
        isMigrationExample: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.code = code
        self.language = language
        self.beforeCode = beforeCode
        self.afterCode = afterCode
        self.annotations = annotations
        self.relatedTopicId = relatedTopicId
        self.isMigrationExample = isMigrationExample
    }
}
