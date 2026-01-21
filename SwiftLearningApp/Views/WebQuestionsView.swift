//
//  WebQuestionsView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

struct WebQuestionsView: View {
    @State private var webQuestionService = WebQuestionService.shared
    @State private var questions: [WebQuestion] = []
    @State private var isLoading = false
    @State private var selectedQuestion: WebQuestion?
    @State private var showSolution = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Smooth gradient background
                AppColorTheme.smoothGradientBackground
                    .ignoresSafeArea()
                
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 16) {
                            // Header
                            VStack(spacing: 8) {
                                Text("Tough Questions")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(AppColorTheme.primaryText)
                                    .shadow(color: AppColorTheme.exoticPurple.opacity(0.5), radius: 10, x: 0, y: 0)
                                
                                Text("Real-world challenges from the Swift community")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(AppColorTheme.secondaryText)
                            }
                            .padding(.top, 20)
                            .padding(.horizontal)
                            
                            // Questions list
                            ForEach(questions) { question in
                                WebQuestionCardView(question: question) {
                                    selectedQuestion = question
                                    showSolution = false
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Challenges")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(AppColorTheme.darkSurface.opacity(0.95), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .tint(AppColorTheme.exoticCyan)
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
    
    private func loadQuestions() async {
        isLoading = true
        do {
            questions = try await webQuestionService.fetchToughQuestions()
        } catch {
            // Handle error - load from disk
            questions = await WebQuestionService.shared.getCachedQuestions()
            if questions.isEmpty {
                questions = WebQuestionService.loadCachedQuestionsFromDisk()
            }
        }
        isLoading = false
    }
}

struct WebQuestionCardView: View {
    let question: WebQuestion
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    // Source badge
                    HStack(spacing: 4) {
                        Image(systemName: sourceIcon)
                            .font(.system(size: 12))
                        Text(question.sourceType.capitalized)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.2))
                    )
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    // Difficulty badge
                    DifficultyBadgeView(difficulty: question.difficulty)
                    
                    // Upvotes if available
                    if let upvotes = question.upvotes {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.circle.fill")
                            Text("\(upvotes)")
                        }
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.orange)
                    }
                }
                
                Text(question.title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(AppColorTheme.primaryText)
                    .multilineTextAlignment(.leading)
                
                Text(question.question)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(AppColorTheme.secondaryText)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                // Tags
                if !question.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(question.tags.prefix(5), id: \.self) { tag in
                                Text(tag)
                                    .font(.system(size: 12, weight: .medium))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.white.opacity(0.1))
                                    )
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Text("Tap to view solution")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: false)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var sourceIcon: String {
        switch question.sourceType {
        case "reddit": return "globe"
        case "stackoverflow": return "questionmark.circle"
        case "swift-forums": return "message"
        default: return "link"
        }
    }
}

struct DifficultyBadgeView: View {
    let difficulty: Difficulty
    
    var body: some View {
        Text(difficulty.rawValue.capitalized)
            .font(.system(size: 11, weight: .bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(difficultyColor.opacity(0.3))
            )
            .foregroundColor(difficultyColor)
    }
    
    private var difficultyColor: Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .yellow
        case .hard: return .orange
        case .expert: return .red
        }
    }
}

struct WebQuestionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let question: WebQuestion
    @Binding var showSolution: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Smooth gradient background
                AppColorTheme.smoothGradientBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header info
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                DifficultyBadgeView(difficulty: question.difficulty)
                                Spacer()
                                if let upvotes = question.upvotes {
                                    HStack(spacing: 4) {
                                        Image(systemName: "arrow.up.circle.fill")
                                        Text("\(upvotes)")
                                    }
                                    .foregroundColor(.orange)
                                }
                            }
                            
                            Text(question.title)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(AppColorTheme.primaryText)
                                .shadow(color: AppColorTheme.exoticPurple.opacity(0.5), radius: 10, x: 0, y: 0)
                            
                            HStack {
                                Image(systemName: "link")
                                Text(question.source)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Question
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Question")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(AppColorTheme.primaryText)
                            
                            Text(question.question)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(AppColorTheme.secondaryText)
                                .lineSpacing(4)
                        }
                        .padding()
                        .elevatedCardStyle()
                        .padding(.horizontal)
                        
                        // Code snippet if present
                        if let codeSnippet = question.codeSnippet {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Code")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(AppColorTheme.primaryText)
                                    .padding(.horizontal)
                                
                                CodeBlockView(code: codeSnippet)
                                    .padding(.horizontal)
                            }
                        }
                        
                        // Solution toggle
                        Button(action: {
                            withAnimation {
                                showSolution.toggle()
                            }
                        }) {
                            HStack {
                                Text(showSolution ? "Hide Solution" : "Show Solution")
                                    .font(.system(size: 18, weight: .semibold))
                                Image(systemName: showSolution ? "chevron.up" : "chevron.down")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                Group {
                                    if #available(iOS 18.0, *) {
                                        AppColorTheme.meshGradientAccent
                                    } else {
                                        AppColorTheme.fallbackGradientAccent
                                    }
                                }
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColorTheme.exoticCyan.opacity(0.5), lineWidth: 2)
                            )
                            .shadow(color: AppColorTheme.exoticPurple.opacity(0.4), radius: 15, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                        
                        // Solution
                        if showSolution, let solution = question.solution {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Solution")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(AppColorTheme.successColor)
                                
                                Text(solution)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(AppColorTheme.secondaryText)
                                    .lineSpacing(4)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColorTheme.successColor.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColorTheme.successColor.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .shadow(color: AppColorTheme.successColor.opacity(0.2), radius: 10, x: 0, y: 5)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("Challenge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(AppColorTheme.darkSurface.opacity(0.95), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .tint(AppColorTheme.exoticCyan)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    WebQuestionsView()
}
