//
//  CodeExampleViewModel.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation
import SwiftUI
import Observation

/// A view model that manages code examples for topics.
///
/// This observable class loads and manages code examples associated
/// with topics. It supports migration examples that can toggle between
/// "before" and "after" code versions.
///
/// ## Migration Examples
/// For migration examples, the view model can display either the
/// original code (before) or the migrated code (after), allowing
/// users to compare Swift versions.
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
    
    /// Loads code examples for a specific topic.
    ///
    /// - Parameter topicId: The identifier of the topic to load examples for.
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
    
    /// Returns the code to display for a given example.
    ///
    /// For migration examples, this returns either the "before" or "after"
    /// code based on the current toggle state. For regular examples,
    /// it returns the standard code.
    ///
    /// - Parameter example: The code example to get display code for.
    /// - Returns: The code string to display.
    func getDisplayCode(for example: CodeExample) -> String {
        if example.isMigrationExample {
            return showBeforeCode ? (example.beforeCode ?? example.code) : (example.afterCode ?? example.code)
        }
        return example.code
    }
}
