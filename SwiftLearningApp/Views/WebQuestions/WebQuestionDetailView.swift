//
//  WebQuestionDetailView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A detailed view for displaying a web question and its solution.
///
/// This view shows the full question, code snippets, and solution
/// with the ability to toggle solution visibility.
struct WebQuestionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let question: WebQuestion
    @Binding var showSolution: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColorTheme.smoothGradientBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        headerInfoView
                        questionContentView
                        codeSnippetView
                        solutionToggleButton
                        solutionView
                    }
                    .padding(.bottom)
                }
            }
            .standardNavigationBarStyle()
            .navigationTitle("Challenge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var headerInfoView: some View {
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
                .primaryTextStyle()
            
            HStack {
                Image(systemName: "link")
                Text(question.source)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var questionContentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Question")
                .sectionHeaderStyle()
            
            Text(question.question)
                .font(.system(size: 16, weight: .regular))
                .secondaryTextStyle()
                .lineSpacing(4)
        }
        .padding()
        .elevatedCardStyle()
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var codeSnippetView: some View {
        if let codeSnippet = question.codeSnippet {
            VStack(alignment: .leading, spacing: 12) {
                Text("Code")
                    .sectionHeaderStyle()
                    .padding(.horizontal)
                
                CodeBlockView(code: codeSnippet)
                    .padding(.horizontal)
            }
        }
    }
    
    private var solutionToggleButton: some View {
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
    }
    
    @ViewBuilder
    private var solutionView: some View {
        if showSolution, let solution = question.solution {
            VStack(alignment: .leading, spacing: 12) {
                Text("Solution")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(AppColorTheme.successColor)
                
                Text(solution)
                    .font(.system(size: 16, weight: .regular))
                    .secondaryTextStyle()
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
}
