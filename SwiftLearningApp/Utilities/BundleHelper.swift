//
//  BundleHelper.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation

struct BundleHelper {
    /// Lists all JSON files in the bundle for debugging
    nonisolated static func listJSONFiles() -> [String] {
        guard let resourcePath = Bundle.main.resourcePath else {
            return []
        }
        
        var jsonFiles: [String] = []
        let fileManager = FileManager.default
        
        if let enumerator = fileManager.enumerator(atPath: resourcePath) {
            for case let file as String in enumerator {
                if file.hasSuffix(".json") {
                    jsonFiles.append(file)
                }
            }
        }
        
        return jsonFiles.sorted()
    }
    
    /// Finds a JSON file in the bundle, trying multiple paths
    nonisolated static func findJSONFile(name: String, in subdirectories: [String] = []) -> URL? {
        var searchPaths = subdirectories
        searchPaths.append("") // Also try root
        
        for subdir in searchPaths {
            if let url = Bundle.main.url(
                forResource: name,
                withExtension: "json",
                subdirectory: subdir.isEmpty ? nil : subdir
            ) {
                return url
            }
        }
        
        // Try without subdirectory
        return Bundle.main.url(forResource: name, withExtension: "json")
    }
}
