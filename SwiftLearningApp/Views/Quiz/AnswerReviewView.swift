//
//  AnswerReviewView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A view that displays a review of a quiz answer.
///
/// This view shows whether an answer was correct, the user's answer,
/// the correct answer (if wrong), and an explanation.
struct AnswerReviewView: View {
    /// The question that was answered.
    let question: Question
    
    /// The user's answer.
    let userAnswer: String?
    
    /// Whether the answer was correct.
    let isCorrect: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            questionHeaderView
            
            if let userAnswer = userAnswer {
                Text("Your answer: \(userAnswer)")
                    .font(.system(size: 14, weight: .regular))
                    .secondaryTextStyle()
            }
            
            if !isCorrect {
                Text("Correct answer: \(question.correctAnswer)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppColorTheme.successColor)
            }
            
            Text(question.explanation)
                .font(.system(size: 14, weight: .regular))
                .secondaryTextStyle()
                .padding(.top, 4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .elevatedCardStyle()
        .padding(.horizontal)
    }
    
    private var questionHeaderView: some View {
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
                .primaryTextStyle()
        }
    }
}
