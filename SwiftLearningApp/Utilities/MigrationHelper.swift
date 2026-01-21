//
//  MigrationHelper.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation

struct MigrationHelper {
    // Helper functions and examples for migration scenarios
    
    static func getMigrationChecklist() -> [String] {
        return [
            "Enable Swift 6 language mode in project settings",
            "Enable strict concurrency checking",
            "Audit all async/await usage",
            "Replace ObservableObject with @Observable",
            "Update @StateObject to @State for @Observable types",
            "Add @MainActor where UI updates occur",
            "Mark types as Sendable where needed",
            "Use @preconcurrency for gradual migration",
            "Update unit tests to use async/await",
            "Test for data races and deadlocks"
        ]
    }
    
    static func getCommonMistakes() -> [(title: String, description: String, fix: String)] {
        return [
            (
                title: "Calling actor methods without await",
                description: "In Swift 6, all actor method calls require await, even if they don't suspend.",
                fix: "Always use await when calling actor methods from outside the actor."
            ),
            (
                title: "Using @StateObject with @Observable",
                description: "@Observable types should use @State, not @StateObject.",
                fix: "Replace @StateObject with @State when using @Observable classes."
            ),
            (
                title: "Heavy computation on @MainActor",
                description: "Doing heavy work on @MainActor blocks the UI thread.",
                fix: "Move heavy computation off @MainActor and only update UI properties on it."
            ),
            (
                title: "Ignoring task cancellation",
                description: "Tasks don't automatically cancel - you need to check for cancellation.",
                fix: "Use Task.checkCancellation() or check Task.isCancelled in loops."
            ),
            (
                title: "Not marking Sendable types",
                description: "Types crossing actor boundaries must conform to Sendable.",
                fix: "Make types Sendable or use actors for mutable shared state."
            )
        ]
    }
}
