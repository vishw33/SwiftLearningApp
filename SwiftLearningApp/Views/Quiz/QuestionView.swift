//
//  QuestionView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A view that displays a single quiz question with answer options.
///
/// This view shows the question text, optional code snippets, and provides
/// interface for users to select answers and navigate between questions.
struct QuestionView: View {
    /// The question to display.
    let question: Question
    
    /// The quiz view model for managing quiz state.
    @Bindable var quizViewModel: QuizViewModel
    
    @State private var selectedAnswer: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                progressBarView
                questionContentView
                answerOptionsView
                navigationButtonsView
            }
        }
        .onAppear {
            selectedAnswer = quizViewModel.getAnswerForQuestion(question.id) ?? ""
        }
    }
    
    // MARK: - Subviews
    
    private var progressBarView: some View {
        SwiftUI.ProgressView(value: quizViewModel.progress, total: 1.0)
            .tint(AppColorTheme.exoticCyan)
            .background(Color.white.opacity(0.1))
            .cornerRadius(4)
            .padding(.horizontal)
            .shadow(color: AppColorTheme.exoticCyan.opacity(0.3), radius: 5, x: 0, y: 0)
    }
    
    private var questionContentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Question \(quizViewModel.currentQuestionIndex + 1) of \(quizViewModel.questions.count)")
                .font(.system(size: 14, weight: .medium))
                .tertiaryTextStyle()
            
            Text(question.question)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .primaryTextStyle()
            
            if let codeSnippet = question.codeSnippet {
                CodeBlockView(code: codeSnippet)
            }
        }
        .padding()
        .elevatedCardStyle()
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var answerOptionsView: some View {
        if question.type == .multipleChoice || question.type == .trueFalse {
            VStack(spacing: 12) {
                ForEach(question.options ?? [], id: \.self) { option in
                    AnswerOptionView(
                        option: option,
                        isSelected: selectedAnswer == option,
                        action: {
                            selectedAnswer = option
                            quizViewModel.submitAnswer(questionId: question.id, answer: option)
                        }
                    )
                }
            }
            .padding(.horizontal)
        } else {
            TextField("Your answer", text: $selectedAnswer)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .onChange(of: selectedAnswer) { _, newValue in
                    quizViewModel.submitAnswer(questionId: question.id, answer: newValue)
                }
        }
    }
    
    private var navigationButtonsView: some View {
        HStack(spacing: 16) {
            if quizViewModel.currentQuestionIndex > 0 {
                Button("Previous") {
                    quizViewModel.previousQuestion()
                    if let current = quizViewModel.currentQuestion {
                        selectedAnswer = quizViewModel.getAnswerForQuestion(current.id) ?? ""
                    }
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
            
            if quizViewModel.isLastQuestion {
                Button("Finish Quiz") {
                    quizViewModel.finishQuiz()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Button("Next") {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        quizViewModel.nextQuestion()
                    }
                    if let current = quizViewModel.currentQuestion {
                        selectedAnswer = quizViewModel.getAnswerForQuestion(current.id) ?? ""
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}
