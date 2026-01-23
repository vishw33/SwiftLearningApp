//
//  QuizView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// The main view for displaying and taking quizzes.
///
/// This view manages the quiz flow, displaying questions, handling answers,
/// and showing results upon completion.
struct QuizView: View {
    @Environment(LearningViewModel.self) private var learningViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var quizViewModel = QuizViewModel()
    let topicId: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColorTheme.smoothGradientBackground
                    .ignoresSafeArea()
                
                contentView
            }
            .standardNavigationBarStyle()
            .navigationTitle("Quiz")
            .inlineNavigationBarTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await quizViewModel.loadQuestions(for: topicId)
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var contentView: some View {
        if quizViewModel.isLoading {
            ProgressView()
                .tint(.white)
        } else if quizViewModel.showResults {
            QuizResultsView(quizViewModel: quizViewModel, topicId: topicId)
                .transition(.scale.combined(with: .opacity))
        } else if let question = quizViewModel.currentQuestion {
            QuestionView(question: question, quizViewModel: quizViewModel)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
        } else {
            Text("No questions available")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    QuizView(topicId: "test")
        .environment(LearningViewModel())
}
