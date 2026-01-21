//
//  ProgressService.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation

@MainActor
class ProgressService {
    static let shared = ProgressService()
    
    private let progressKey = "SwiftLearningApp.Progress"
    
    private init() {}
    
    func loadProgress() -> LearningProgress {
        guard let data = UserDefaults.standard.data(forKey: progressKey),
              let progress = try? JSONDecoder().decode(LearningProgress.self, from: data) else {
            return LearningProgress()
        }
        return progress
    }
    
    func saveProgress(_ progress: LearningProgress) {
        if let encoded = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(encoded, forKey: progressKey)
        }
    }
    
    func resetProgress() {
        UserDefaults.standard.removeObject(forKey: progressKey)
    }
}
