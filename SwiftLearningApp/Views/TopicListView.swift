//
//  TopicListView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// The main view that displays a list of learning topics.
///
/// This view provides two layout modes: grid and paginated, allowing users
/// to browse topics in different visual formats. It handles loading states,
/// errors, and navigation to topic details.
struct TopicListView: View {
    @Environment(LearningViewModel.self) private var viewModel
    @State private var navigationPath = NavigationPath()
    @State private var isPaginatedLayout = false
    @State private var currentPageIndex = 0
    @State private var hasAppeared = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                backgroundView
                
                VStack(spacing: 0) {
                    headerSection
                    
                    contentView
                }
            }
            .standardNavigationBarStyle()
            .navigationTitle("Swift Learning")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(isPaginatedLayout ? .hidden : .visible, for: .navigationBar)
            .navigationDestination(for: Topic.self) { topic in
                TopicDetailView(topic: topic)
                    .transition(.move(edge: .trailing))
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.topics.count)
            .onAppear {
                withAnimation(.interpolatingSpring(stiffness: 150, damping: 18)) {
                    hasAppeared = true
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var backgroundView: some View {
        ZStack {
            AppColorTheme.smoothGradientBackground
            
            if !viewModel.topics.isEmpty && isPaginatedLayout && currentPageIndex < viewModel.topics.count {
                dynamicGlowView
            }
        }
        .ignoresSafeArea(.all)
    }
    
    private var dynamicGlowView: some View {
        let currentTopicColor = AppColorTheme.topicColor(for: viewModel.topics[currentPageIndex].id)
        return Circle()
            .fill(
                RadialGradient(
                    colors: [currentTopicColor.opacity(0.25), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: 400
                )
            )
            .frame(width: 800, height: 800)
            .animation(.interpolatingSpring(stiffness: 100, damping: 15), value: currentPageIndex)
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HeaderSectionView()
            
            LayoutToggleView(isPaginatedLayout: $isPaginatedLayout)
                .onChange(of: isPaginatedLayout) { _, newValue in
                    if newValue {
                        currentPageIndex = 0
                    }
                }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
        .padding(.bottom, isPaginatedLayout ? 16 : 0)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            loadingView
        } else if let error = viewModel.errorMessage {
            errorView(error: error)
        } else if viewModel.topics.isEmpty {
            emptyStateView
        } else {
            topicContentView
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            SwiftUI.ProgressView()
                .padding()
            Spacer()
        }
    }
    
    private func errorView(error: String) -> some View {
        VStack {
            Spacer()
            VStack(spacing: 12) {
                Text("Error Loading Topics")
                    .font(.headline)
                    .foregroundColor(.red)
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            Spacer()
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                Text("No topics found")
                    .font(.headline)
                    .primaryTextStyle()
                Text("Please check that JSON files are included in the app bundle")
                    .font(.caption)
                    .secondaryTextStyle()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            Spacer()
        }
    }
    
    @ViewBuilder
    private var topicContentView: some View {
        if isPaginatedLayout {
            PaginatedTopicListView(
                topics: viewModel.topics,
                currentPageIndex: $currentPageIndex,
                hasAppeared: hasAppeared,
                onTopicSelected: { topic in
                    viewModel.startTopic(topic)
                    navigationPath.append(topic)
                },
                onBackPressed: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isPaginatedLayout = false
                        currentPageIndex = 0
                    }
                }
            )
        } else {
            GridTopicListView(
                topics: viewModel.topics,
                onTopicSelected: { topic in
                    viewModel.startTopic(topic)
                    navigationPath.append(topic)
                }
            )
        }
    }
}

// MARK: - Paginated Topic List View

/// A view that displays topics in a paginated carousel format.
private struct PaginatedTopicListView: View {
    let topics: [Topic]
    @Binding var currentPageIndex: Int
    let hasAppeared: Bool
    let onTopicSelected: (Topic) -> Void
    let onBackPressed: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    topicTitleView
                    paginatedCarousel(geometry: geometry)
                    PageIndicatorView(
                        totalPages: topics.count,
                        currentPageIndex: $currentPageIndex,
                        topics: topics
                    )
                    .opacity(hasAppeared ? 1 : 0)
                    .offset(y: hasAppeared ? 0 : 20)
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: geometry.size.width)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
            .overlay(alignment: .topLeading) {
                backButton
            }
        }
    }
    
    @ViewBuilder
    private var topicTitleView: some View {
        if !topics.isEmpty && currentPageIndex < topics.count {
            let currentTopic = topics[currentPageIndex]
            let topicColor = AppColorTheme.topicColor(for: currentTopic.id)
            
            Text(currentTopic.title)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(topicColor)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity)
                .contentTransition(.interpolate)
                .id("topicTitle-\(currentPageIndex)")
                .animation(.interpolatingSpring(stiffness: 300, damping: 25), value: currentPageIndex)
                .padding(.horizontal, 20)
                .padding(.top, 80)
                .padding(.bottom, 8)
        }
    }
    
    private func paginatedCarousel(geometry: GeometryProxy) -> some View {
        TabView(selection: $currentPageIndex) {
            ForEach(Array(topics.enumerated()), id: \.element.id) { index, topic in
                PaginatedTopicCardView(topic: topic) {
                    onTopicSelected(topic)
                }
                .frame(width: min(280, geometry.size.width - 40), height: 400)
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 400)
        .frame(maxWidth: geometry.size.width)
        .geometryGroup()
        .animation(.interpolatingSpring(stiffness: 300, damping: 28), value: currentPageIndex)
        .opacity(hasAppeared ? 1 : 0)
    }
    
    private var backButton: some View {
        Button(action: onBackPressed) {
            HStack(spacing: 6) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                Text("Back")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.85))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(AppColorTheme.exoticCyan, lineWidth: 2.5)
                    )
            )
            .shadow(color: AppColorTheme.exoticCyan.opacity(0.7), radius: 20, x: 0, y: 5)
        }
        .padding(.leading, 20)
        .padding(.top, 50)
    }
}

// MARK: - Grid Topic List View

/// A view that displays topics in a grid layout.
private struct GridTopicListView: View {
    let topics: [Topic]
    let onTopicSelected: (Topic) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true) {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach(topics) { topic in
                        TopicCardView(topic: topic) {
                            onTopicSelected(topic)
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .frame(maxWidth: geometry.size.width)
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    TopicListView()
        .environment(LearningViewModel())
}
