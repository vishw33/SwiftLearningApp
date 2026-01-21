//
//  QuizView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

struct QuizView: View {
    @Environment(LearningViewModel.self) private var learningViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var quizViewModel = QuizViewModel()
    let topicId: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Smooth gradient background
                AppColorTheme.smoothGradientBackground
                    .ignoresSafeArea()
                
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
            .navigationTitle("Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(AppColorTheme.darkSurface.opacity(0.95), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .tint(AppColorTheme.exoticCyan)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
}

struct QuestionView: View {
    let question: Question
    @Bindable var quizViewModel: QuizViewModel
    @State private var selectedAnswer: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Progress bar
                SwiftUI.ProgressView(value: quizViewModel.progress, total: 1.0)
                    .tint(AppColorTheme.exoticCyan)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(4)
                    .padding(.horizontal)
                    .shadow(color: AppColorTheme.exoticCyan.opacity(0.3), radius: 5, x: 0, y: 0)
                
                // Question
                VStack(alignment: .leading, spacing: 16) {
                    Text("Question \(quizViewModel.currentQuestionIndex + 1) of \(quizViewModel.questions.count)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColorTheme.tertiaryText)
                    
                    Text(question.question)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(AppColorTheme.primaryText)
                    
                    // Code snippet if present
                    if let codeSnippet = question.codeSnippet {
                        CodeBlockView(code: codeSnippet)
                    }
                }
                .padding()
                .elevatedCardStyle()
                .padding(.horizontal)
                
                // Answer options
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
                    // Code completion or other types
                    TextField("Your answer", text: $selectedAnswer)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .onChange(of: selectedAnswer) { _, newValue in
                            quizViewModel.submitAnswer(questionId: question.id, answer: newValue)
                        }
                }
                
                // Navigation buttons
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
        .onAppear {
            selectedAnswer = quizViewModel.getAnswerForQuestion(question.id) ?? ""
        }
    }
}

struct AnswerOptionView: View {
    let option: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(option)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(AppColorTheme.primaryText)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppColorTheme.exoticCyan)
                        .shadow(color: AppColorTheme.exoticCyan.opacity(0.5), radius: 5, x: 0, y: 0)
                }
            }
            .padding()
            .background(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        AppColorTheme.exoticPurple.opacity(0.4),
                                        AppColorTheme.exoticCyan.opacity(0.4)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColorTheme.exoticCyan, lineWidth: 2)
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColorTheme.exoticCyan.opacity(0.3), lineWidth: 1.5)
                            )
                    }
                }
            )
            .shadow(
                color: isSelected ? AppColorTheme.exoticPurple.opacity(0.3) : .black.opacity(0.2),
                radius: isSelected ? 10 : 5,
                x: 0,
                y: isSelected ? 5 : 2
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isSelected)
    }
}

struct CodeBlockView: View {
    let code: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.white)
                .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.3))
        )
    }
}

struct QuizResultsView: View {
    @Environment(LearningViewModel.self) private var learningViewModel
    @Environment(\.dismiss) private var dismiss
    @Bindable var quizViewModel: QuizViewModel
    let topicId: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Score display
                VStack(spacing: 16) {
                    Text("Quiz Complete!")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(AppColorTheme.primaryText)
                        .shadow(color: AppColorTheme.exoticPurple.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Text("\(Int(quizViewModel.score * 100))%")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundColor(scoreColor)
                        .shadow(color: scoreColor.opacity(0.5), radius: 15, x: 0, y: 0)
                    
                    Text(scoreMessage)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(AppColorTheme.secondaryText)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .cardStyle(hasGlow: true)
                .padding(.horizontal)
                
                // Review answers
                VStack(alignment: .leading, spacing: 16) {
                    Text("Review Answers")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ForEach(quizViewModel.questions) { question in
                        AnswerReviewView(
                            question: question,
                            userAnswer: quizViewModel.getAnswerForQuestion(question.id),
                            isCorrect: quizViewModel.isAnswerCorrect(question.id) ?? false
                        )
                    }
                }
                
                // Action buttons
                VStack(spacing: 12) {
                    Button("Done") {
                        learningViewModel.completeQuiz(
                            score: quizViewModel.score,
                            topicId: topicId
                        )
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
    
    private var scoreColor: Color {
        if quizViewModel.score >= 0.8 {
            return AppColorTheme.successColor
        } else if quizViewModel.score >= 0.6 {
            return AppColorTheme.warningColor
        } else {
            return AppColorTheme.errorColor
        }
    }
    
    private var scoreMessage: String {
        if quizViewModel.score >= 0.9 {
            return "Excellent! You've mastered this topic!"
        } else if quizViewModel.score >= 0.7 {
            return "Great job! You understand the concepts well."
        } else if quizViewModel.score >= 0.5 {
            return "Good effort! Review the topics and try again."
        } else {
            return "Keep practicing! Review the material and try again."
        }
    }
}

struct AnswerReviewView: View {
    let question: Question
    let userAnswer: String?
    let isCorrect: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(isCorrect ? AppColorTheme.successColor : AppColorTheme.errorColor)
                    .shadow(
                        color: isCorrect ? AppColorTheme.successColor.opacity(0.5) : AppColorTheme.errorColor.opacity(0.5),
                        radius: 5,
                        x: 0,
                        y: 0
                    )
                
                Text(question.question)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColorTheme.primaryText)
            }
            
            if let userAnswer = userAnswer {
                Text("Your answer: \(userAnswer)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppColorTheme.secondaryText)
            }
            
            if !isCorrect {
                Text("Correct answer: \(question.correctAnswer)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppColorTheme.successColor)
            }
            
            Text(question.explanation)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(AppColorTheme.secondaryText)
                .padding(.top, 4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .elevatedCardStyle()
        .padding(.horizontal)
    }
}

#Preview {
    QuizView(topicId: "test")
        .environment(LearningViewModel())
}
