//
//  ContentView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(LearningViewModel.self) private var viewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TopicListView()
                .tabItem {
                    Label("Topics", systemImage: "book.fill")
                }
                .tag(0)
            
            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
                .tag(1)
            
            WebQuestionsView()
                .tabItem {
                    Label("Challenges", systemImage: "brain.head.profile")
                }
                .tag(2)
        }
        .task {
            await viewModel.loadTopics()
        }
    }
}

#Preview {
    ContentView()
        .environment(LearningViewModel())
}
