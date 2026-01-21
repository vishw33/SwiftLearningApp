//
//  Topic.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation
import Observation

struct TopicSection: Identifiable, Codable {
    let id: String
    let title: String
    let content: String
    let codeExampleIds: [String]
}

@Observable
@MainActor
final class Topic: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let sections: [TopicSection]
    let codeExampleIds: [String]
    let questionIds: [String]
    var isCompleted: Bool
    var progress: Double
    
    init(
        id: String,
        title: String,
        description: String,
        sections: [TopicSection] = [],
        codeExampleIds: [String] = [],
        questionIds: [String] = [],
        isCompleted: Bool = false,
        progress: Double = 0.0
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.sections = sections
        self.codeExampleIds = codeExampleIds
        self.questionIds = questionIds
        self.isCompleted = isCompleted
        self.progress = progress
    }
}

extension Topic: Codable {
    enum CodingKeys: String, CodingKey {
        case id, title, description, sections
        case codeExampleIds, questionIds
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let description = try container.decode(String.self, forKey: .description)
        let sections = try container.decode([TopicSection].self, forKey: .sections)
        let codeExampleIds = try container.decodeIfPresent([String].self, forKey: .codeExampleIds) ?? []
        let questionIds = try container.decodeIfPresent([String].self, forKey: .questionIds) ?? []
        self.init(
            id: id,
            title: title,
            description: description,
            sections: sections,
            codeExampleIds: codeExampleIds,
            questionIds: questionIds,
            isCompleted: false,
            progress: 0.0
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(sections, forKey: .sections)
        try container.encode(codeExampleIds, forKey: .codeExampleIds)
        try container.encode(questionIds, forKey: .questionIds)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Topic, rhs: Topic) -> Bool {
        lhs.id == rhs.id
    }
}
