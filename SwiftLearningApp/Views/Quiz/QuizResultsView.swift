//
//  QuizResultsView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A view that displays quiz results and score.
///
/// This view shows the final quiz score, performance message, and
/// allows users to review their answers.
struct QuizResultsView: View {
    @Environment(LearningViewModel.self) private var learningViewModel
    @Environment(\.dismiss) private var dismiss
    @Bindable var quizViewModel: QuizViewModel
    let topicId: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                scoreDisplayView
                answerReviewSection
                actionButtonsView
            }
        }
    }
    
    // MARK: - Subviews
    
    private var scoreDisplayView: some View {
        VStack(spacing: 16) {
            Text("Quiz Complete!")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .primaryTextStyle()
            
            Text("\(Int(quizViewModel.score * 100))%")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundColor(scoreColor)
                .shadow(color: scoreColor.opacity(0.5), radius: 15, x: 0, y: 0)
            
            Text(scoreMessage)
                .font(.system(size: 18, weight: .regular))
                .secondaryTextStyle()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .cardStyle(hasGlow: true)
        .padding(.horizontal)
    }
    
    private var answerReviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Review Answers")
                .sectionHeaderStyle()
                .padding(.horizontal)
            
            ForEach(quizViewModel.questions) { question in
                AnswerReviewView(
                    question: question,
                    userAnswer: quizViewModel.getAnswerForQuestion(question.id),
                    isCorrect: quizViewModel.isAnswerCorrect(question.id) ?? false
                )
            }
        }
    }
    
    private var actionButtonsView: some View {
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
    
    // MARK: - Computed Properties
    
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
