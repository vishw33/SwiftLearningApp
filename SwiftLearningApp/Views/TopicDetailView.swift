//
//  TopicDetailView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// The main view that displays detailed information about a topic.
///
/// This view shows topic title, description, sections, code examples,
/// and provides access to quizzes for the topic.
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
                headerView
                sectionsView
                codeExamplesView
                startQuizButton
            }
        }
        .standardBackground()
        .standardNavigationBarStyle()
        .inlineNavigationBarTitle()
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
    
    // MARK: - Subviews
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(topic.title)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .primaryTextStyle(shadowColor: topicColor)
            
            Text(topic.description)
                .font(.system(size: 16, weight: .regular))
                .secondaryTextStyle()
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var sectionsView: some View {
        ForEach(topic.sections) { section in
            TopicSectionView(section: section, topicColor: topicColor)
        }
    }
    
    @ViewBuilder
    private var codeExamplesView: some View {
        if !codeExampleViewModel.codeExamples.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text("Code Examples")
                    .titleStyle(size: 24)
                    .padding(.horizontal)
                
                ForEach(codeExampleViewModel.codeExamples) { example in
                    CodeExampleCardView(example: example, action: {
                        selectedExample = example
                    }, topicColor: topicColor)
                }
            }
        }
    }
    
    private var startQuizButton: some View {
        Button(action: {
            showQuiz = true
        }) {
            HStack {
                Image(systemName: "play.circle.fill")
                Text("Start Quiz")
                    .font(.system(size: 18, weight: .semibold))
            }
            .primaryButtonStyle(color: topicColor)
        }
        .padding(.horizontal)
        .padding(.bottom)
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
