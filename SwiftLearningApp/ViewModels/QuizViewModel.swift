//
//  QuizViewModel.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation
import SwiftUI
import Observation

/// A view model that manages quiz state and question navigation.
///
/// This observable class handles loading questions, tracking user answers,
/// calculating scores, and managing quiz flow. It provides computed
/// properties for current question, progress, and completion status.
///
/// ## Question Navigation
/// The view model supports forward and backward navigation through
/// questions, allowing users to review and change answers before
/// completing the quiz.
///
/// ## Score Calculation
/// Scores are calculated based on correct answers when the quiz is
/// finished, with results displayed in the results view.
@Observable
@MainActor
class QuizViewModel {
    var questions: [Question] = []
    var currentQuestionIndex: Int = 0
    var userAnswers: [String: String] = [:]
    var showResults: Bool = false
    var score: Double = 0.0
    var isLoading: Bool = false
    var errorMessage: String?
    
    private let contentService: ContentService
    
    init(contentService: ContentService = ContentService.shared) {
        self.contentService = contentService
    }
    
    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var progress: Double {
        guard !questions.isEmpty else { return 0.0 }
        return Double(currentQuestionIndex + 1) / Double(questions.count)
    }
    
    var isLastQuestion: Bool {
        currentQuestionIndex >= questions.count - 1
    }
    
    /// Loads questions for a specific topic.
    ///
    /// This method resets the quiz state and loads questions from
    /// the content service. The quiz is reset to the first question
    /// with all previous answers cleared.
    ///
    /// - Parameter topicId: The identifier of the topic to load questions for.
    func loadQuestions(for topicId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            questions = try await contentService.loadQuestions(for: topicId)
            currentQuestionIndex = 0
            userAnswers = [:]
            showResults = false
            score = 0.0
        } catch {
            errorMessage = "Failed to load questions: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    /// Records a user's answer for a specific question.
    ///
    /// - Parameters:
    ///   - questionId: The identifier of the question.
    ///   - answer: The answer provided by the user.
    func submitAnswer(questionId: String, answer: String) {
        userAnswers[questionId] = answer
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        }
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
    
    /// Calculates the quiz score based on correct answers.
    ///
    /// This method compares user answers with correct answers and
    /// returns a score between 0.0 and 1.0.
    ///
    /// - Returns: The quiz score as a value between 0.0 and 1.0.
    func calculateScore() -> Double {
        guard !questions.isEmpty else { return 0.0 }
        
        var correctAnswers = 0
        for question in questions {
            if let userAnswer = userAnswers[question.id],
               userAnswer == question.correctAnswer {
                correctAnswers += 1
            }
        }
        
        score = Double(correctAnswers) / Double(questions.count)
        return score
    }
    
    func finishQuiz() {
        calculateScore()
        showResults = true
    }
    
    func reset() {
        questions = []
        currentQuestionIndex = 0
        userAnswers = [:]
        showResults = false
        score = 0.0
    }
    
    func getAnswerForQuestion(_ questionId: String) -> String? {
        return userAnswers[questionId]
    }
    
    func isAnswerCorrect(_ questionId: String) -> Bool? {
        guard let question = questions.first(where: { $0.id == questionId }),
              let userAnswer = userAnswers[questionId] else {
            return nil
        }
        return userAnswer == question.correctAnswer
    }
}
