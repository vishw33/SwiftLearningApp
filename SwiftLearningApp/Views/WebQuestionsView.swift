//
//  WebQuestionsView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// The main view for displaying web-based challenging questions.
///
/// This view loads and displays tough questions from various sources
/// including Reddit, Stack Overflow, and Swift Forums.
struct WebQuestionsView: View {
    @State private var webQuestionService = WebQuestionService.shared
    @State private var questions: [WebQuestion] = []
    @State private var isLoading = false
    @State private var selectedQuestion: WebQuestion?
    @State private var showSolution = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColorTheme.smoothGradientBackground
                    .ignoresSafeArea()
                
                contentView
            }
            .standardNavigationBarStyle()
            .navigationTitle("Challenges")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await loadQuestions()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .task {
                await loadQuestions()
            }
            .sheet(item: $selectedQuestion) { question in
                WebQuestionDetailView(question: question, showSolution: $showSolution)
            }
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var contentView: some View {
        if isLoading {
            ProgressView()
                .tint(.white)
        } else {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 16) {
                    headerView
                    questionsListView
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Tough Questions")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .primaryTextStyle()
            
            Text("Real-world challenges from the Swift community")
                .font(.system(size: 16, weight: .regular))
                .secondaryTextStyle()
        }
        .padding(.top, 20)
        .padding(.horizontal)
    }
    
    private var questionsListView: some View {
        ForEach(questions) { question in
            WebQuestionCardView(question: question) {
                selectedQuestion = question
                showSolution = false
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Methods
    
    private func loadQuestions() async {
        isLoading = true
        do {
            questions = try await webQuestionService.fetchToughQuestions()
        } catch {
            questions = await WebQuestionService.shared.getCachedQuestions()
            if questions.isEmpty {
                questions = WebQuestionService.loadCachedQuestionsFromDisk()
            }
        }
        isLoading = false
    }
}

#Preview {
    WebQuestionsView()
}
