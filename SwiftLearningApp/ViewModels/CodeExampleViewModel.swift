//
//  CodeExampleViewModel.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation
import SwiftUI
import Observation

@Observable
@MainActor
class CodeExampleViewModel {
    var codeExamples: [CodeExample] = []
    var currentExample: CodeExample?
    var showBeforeCode: Bool = true // For migration examples
    var isLoading: Bool = false
    var errorMessage: String?
    
    private let contentService: ContentService
    
    init(contentService: ContentService = ContentService.shared) {
        self.contentService = contentService
    }
    
    func loadExamples(for topicId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            codeExamples = try await contentService.loadCodeExamples(for: topicId)
        } catch {
            errorMessage = "Failed to load code examples: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func selectExample(_ example: CodeExample) {
        currentExample = example
        if example.isMigrationExample {
            showBeforeCode = true
        }
    }
    
    func toggleBeforeAfter() {
        showBeforeCode.toggle()
    }
    
    func getDisplayCode(for example: CodeExample) -> String {
        if example.isMigrationExample {
            return showBeforeCode ? (example.beforeCode ?? example.code) : (example.afterCode ?? example.code)
        }
        return example.code
    }
}
