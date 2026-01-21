//
//  SwiftLearningApp.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

@main
struct SwiftLearningApp: App {
    @State private var learningViewModel = LearningViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(learningViewModel)
                .ignoresSafeArea(.all)
        }
    }
}
