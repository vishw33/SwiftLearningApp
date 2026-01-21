//
//  CodeHighlighter.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation
import SwiftUI

struct CodeHighlighter {
    // Simple syntax highlighting for Swift code
    // In a production app, you might use a more sophisticated library
    
    static func highlightSwift(_ code: String) -> AttributedString {
        var attributedString = AttributedString(code)
        
        // Keywords
        let keywords = [
            "func", "var", "let", "class", "struct", "enum", "actor",
            "async", "await", "throws", "try", "catch", "if", "else",
            "for", "while", "switch", "case", "default", "return",
            "import", "public", "private", "internal", "static",
            "final", "override", "init", "deinit", "self", "super",
            "@Observable", "@MainActor", "@State", "@Published",
            "Task", "TaskGroup", "Sendable", "nonisolated"
        ]
        
        for keyword in keywords {
            let pattern = "\\b\(keyword)\\b"
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                let nsString = code as NSString
                let matches = regex.matches(in: code, options: [], range: NSRange(location: 0, length: nsString.length))
                
                for match in matches.reversed() {
                    let range = Range(match.range, in: code)!
                    if let swiftRange = Range(range, in: attributedString) {
                        attributedString[swiftRange].foregroundColor = .purple
                        attributedString[swiftRange].font = .system(.body, design: .monospaced).bold()
                    }
                }
            }
        }
        
        // Strings
        if let stringRegex = try? NSRegularExpression(pattern: "\"[^\"]*\"", options: []) {
            let nsString = code as NSString
            let matches = stringRegex.matches(in: code, options: [], range: NSRange(location: 0, length: nsString.length))
            
            for match in matches.reversed() {
                let range = Range(match.range, in: code)!
                if let swiftRange = Range(range, in: attributedString) {
                    attributedString[swiftRange].foregroundColor = .green
                    attributedString[swiftRange].font = .system(.body, design: .monospaced)
                }
            }
        }
        
        // Comments
        if let commentRegex = try? NSRegularExpression(pattern: "//.*", options: []) {
            let nsString = code as NSString
            let matches = commentRegex.matches(in: code, options: [], range: NSRange(location: 0, length: nsString.length))
            
            for match in matches.reversed() {
                let range = Range(match.range, in: code)!
                if let swiftRange = Range(range, in: attributedString) {
                    attributedString[swiftRange].foregroundColor = .gray
                    attributedString[swiftRange].font = .system(.body, design: .monospaced)
                }
            }
        }
        
        // Set default font
        attributedString.font = .system(.body, design: .monospaced)
        
        return attributedString
    }
}
