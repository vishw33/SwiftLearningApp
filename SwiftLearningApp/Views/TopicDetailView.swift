//
//  TopicDetailView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

struct TopicDetailView: View {
    @Environment(LearningViewModel.self) private var viewModel
    let topic: Topic
    @State private var codeExampleViewModel = CodeExampleViewModel()
    @State private var showQuiz = false
    @State private var selectedExample: CodeExample?
    
    private var topicColor: Color {
        AppColorTheme.topicColor(for: topic.id)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(topic.title)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(AppColorTheme.primaryText)
                        .shadow(color: topicColor.opacity(0.6), radius: 15, x: 0, y: 0)
                    
                    Text(topic.description)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(AppColorTheme.secondaryText)
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Sections
                ForEach(topic.sections) { section in
                    TopicSectionView(section: section, topicColor: topicColor)
                }
                
                // Code Examples
                if !codeExampleViewModel.codeExamples.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Code Examples")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(AppColorTheme.primaryText)
                            .padding(.horizontal)
                        
                        ForEach(codeExampleViewModel.codeExamples) { example in
                            CodeExampleCardView(example: example, action: {
                                selectedExample = example
                            }, topicColor: topicColor)
                        }
                    }
                }
                
                // Start Quiz Button
                Button(action: {
                    showQuiz = true
                }) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                        Text("Start Quiz")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [topicColor, topicColor.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(topicColor.opacity(0.6), lineWidth: 2)
                    )
                    .shadow(color: topicColor.opacity(0.5), radius: 20, x: 0, y: 8)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(
            AppColorTheme.smoothGradientBackground
                .ignoresSafeArea()
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(AppColorTheme.darkSurface.opacity(0.95), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .tint(topicColor)
        .task {
            await codeExampleViewModel.loadExamples(for: topic.id)
        }
        .sheet(isPresented: $showQuiz) {
            QuizView(topicId: topic.id)
        }
        .sheet(item: $selectedExample) { example in
            CodeExampleView(example: example, viewModel: codeExampleViewModel)
        }
    }
}

struct TopicSectionView: View {
    let section: TopicSection
    let topicColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(AppColorTheme.primaryText)
            
            Text(section.content)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(AppColorTheme.secondaryText)
                .lineSpacing(4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(white: 0.15),
                            Color(white: 0.08)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [
                                    topicColor.opacity(0.1),
                                    topicColor.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [topicColor.opacity(0.3), topicColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: topicColor.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct CodeExampleCardView: View {
    let example: CodeExample
    let action: () -> Void
    let topicColor: Color
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Text(example.title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(AppColorTheme.primaryText)
                
                Text(example.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppColorTheme.secondaryText)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "chevron.right")
                        .foregroundColor(topicColor)
                        .shadow(color: topicColor.opacity(0.5), radius: 5, x: 0, y: 0)
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(white: 0.15),
                                Color(white: 0.08)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        topicColor.opacity(0.1),
                                        topicColor.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            colors: [topicColor.opacity(0.3), topicColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: topicColor.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        TopicDetailView(
            topic: Topic(
                id: "test",
                title: "Test Topic",
                description: "Test description",
                sections: [
                    TopicSection(
                        id: "s1",
                        title: "Section 1",
                        content: "Content here",
                        codeExampleIds: []
                    )
                ]
            )
        )
        .environment(LearningViewModel())
    }
}
