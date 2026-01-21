//
//  TopicListView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

struct TopicListView: View {
    @Environment(LearningViewModel.self) private var viewModel
    @State private var navigationPath = NavigationPath()
    @State private var isPaginatedLayout = false
    @State private var currentPageIndex = 0
    @State private var hasAppeared = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                // Smooth gradient background with dynamic glow
                ZStack {
                    AppColorTheme.smoothGradientBackground
                    
                    // Dynamic glow based on current topic
                    if !viewModel.topics.isEmpty && isPaginatedLayout && currentPageIndex < viewModel.topics.count {
                        let currentTopicColor = AppColorTheme.topicColor(for: viewModel.topics[currentPageIndex].id)
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [currentTopicColor.opacity(0.25), .clear],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 400
                                )
                            )
                            .frame(width: 800, height: 800)
                            //.offset(y: 100)
                            .animation(.interpolatingSpring(stiffness: 100, damping: 15), value: currentPageIndex)
                    }
                }
                .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header with layout toggle - always visible
                    VStack(spacing: 16) {
                        headerSection
                        
                        // Layout Toggle - always visible
                        HStack(alignment:.center) {
                            Text("Layout")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColorTheme.secondaryText)
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        isPaginatedLayout = false
                                        currentPageIndex = 0
                                    }
                                }) {
                                    Image(systemName: "square.grid.2x2")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(isPaginatedLayout ? AppColorTheme.tertiaryText : AppColorTheme.exoticCyan)
                                        .frame(width: 40, height: 32)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(isPaginatedLayout ? Color.clear : AppColorTheme.exoticCyan.opacity(0.2))
                                        )
                                }
                                
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        isPaginatedLayout = true
                                        currentPageIndex = 0
                                    }
                                }) {
                                    Image(systemName: "rectangle.stack")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(isPaginatedLayout ? AppColorTheme.exoticCyan : AppColorTheme.tertiaryText)
                                        .frame(width: 40, height: 32)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(isPaginatedLayout ? AppColorTheme.exoticCyan.opacity(0.2) : Color.clear)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(width: 350)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    .padding(.bottom, isPaginatedLayout ? 16 : 0)
                    
                    if viewModel.isLoading {
                        Spacer()
                        SwiftUI.ProgressView()
                            .padding()
                        Spacer()
                    } else if let error = viewModel.errorMessage {
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
                    } else if viewModel.topics.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            Text("No topics found")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Please check that JSON files are included in the app bundle")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding()
                        Spacer()
                    } else {
                        if isPaginatedLayout {
                            // Paginated layout
                            paginatedTopicView
                        } else {
                            // Grid layout
                            GeometryReader { geometry in
                                ScrollView(.vertical, showsIndicators: true) {
                                    LazyVGrid(columns: [
                                        GridItem(.flexible(), spacing: 16),
                                        GridItem(.flexible(), spacing: 16)
                                    ], spacing: 16) {
                                        ForEach(viewModel.topics) { topic in
                                            TopicCardView(topic: topic) {
                                                viewModel.startTopic(topic)
                                                navigationPath.append(topic)
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
                }
            }
            .navigationTitle("Swift Learning")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(AppColorTheme.darkSurface.opacity(0.95), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark)
            .tint(AppColorTheme.exoticCyan)
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
    
    // MARK: - Paginated View
    @ViewBuilder
    private var paginatedTopicView: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Topic title above card
                    if !viewModel.topics.isEmpty && currentPageIndex < viewModel.topics.count {
                        let currentTopic = viewModel.topics[currentPageIndex]
                        let topicColor = AppColorTheme.topicColor(for: currentTopic.id)
                        
                        Text(currentTopic.title)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(topicColor)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .minimumScaleFactor(0.7)
                            .frame(maxWidth: geometry.size.width - 40)
                            .contentTransition(.interpolate)
                            .id("topicTitle-\(currentPageIndex)")
                            .animation(.interpolatingSpring(stiffness: 300, damping: 25), value: currentPageIndex)
                            .padding(.horizontal, 20)
                            .padding(.top, 80) // Extra padding for back button
                            .padding(.bottom, 8)
                    }
                    
                    // Paginated carousel
                    TabView(selection: $currentPageIndex) {
                        ForEach(Array(viewModel.topics.enumerated()), id: \.element.id) { index, topic in
                            PaginatedTopicCardView(topic: topic) {
                                viewModel.startTopic(topic)
                                navigationPath.append(topic)
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
                    
                    // Page indicator
                    if !viewModel.topics.isEmpty {
                        pageIndicator
                            .opacity(hasAppeared ? 1 : 0)
                            .offset(y: hasAppeared ? 0 : 20)
                            .padding(.bottom, 20)
                    }
                }
                .frame(maxWidth: geometry.size.width)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
            .overlay(alignment: .topLeading) {
                // Back button - fixed overlay, always visible
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isPaginatedLayout = false
                        currentPageIndex = 0
                    }
                }) {
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
    }
    
    @ViewBuilder
    private var pageIndicator: some View {
        VStack(spacing: 14) {
            // Animated dots - centered
            HStack(spacing: 8) {
                ForEach(0..<viewModel.topics.count, id: \.self) { index in
                    let topicColor = AppColorTheme.topicColor(for: viewModel.topics[index].id)
                    Capsule()
                        .fill(index == currentPageIndex ? topicColor : Color.white.opacity(0.3))
                        .frame(width: index == currentPageIndex ? 24 : 8, height: 8)
                        .animation(.interpolatingSpring(stiffness: 350, damping: 22), value: currentPageIndex)
                        .onTapGesture {
                            withAnimation(.interpolatingSpring(stiffness: 280, damping: 24)) {
                                currentPageIndex = index
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity)
            
            // Page counter
            Text("\(currentPageIndex + 1) / \(viewModel.topics.count)")
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .foregroundStyle(.white.opacity(0.5))
                .contentTransition(.numericText())
                .animation(.interpolatingSpring(stiffness: 300, damping: 25), value: currentPageIndex)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal)
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Swift 6 Essentials")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(AppColorTheme.primaryText)
                .shadow(color: AppColorTheme.exoticPurple.opacity(0.5), radius: 10, x: 0, y: 0)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity)
            
            Text("Master async/await, concurrency, and modern Swift")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(AppColorTheme.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.9)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

struct TopicCardView: View {
    let topic: Topic
    let action: () -> Void
    
    private var topicColor: Color {
        AppColorTheme.topicColor(for: topic.id)
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 4)
                            .cornerRadius(2)
                        
                        Group {
                            if topic.isCompleted {
                                AppColorTheme.successColor
                            } else {
                                LinearGradient(
                                    colors: [topicColor, topicColor.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            }
                        }
                        .frame(width: geometry.size.width * topic.progress, height: 4)
                        .cornerRadius(2)
                    }
                }
                .frame(height: 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(topic.title)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(AppColorTheme.primaryText)
                        
                        Spacer()
                        
                        if topic.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppColorTheme.successColor)
                                .shadow(color: AppColorTheme.successColor.opacity(0.5), radius: 5, x: 0, y: 0)
                        }
                    }
                    
                    Text(topic.description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppColorTheme.secondaryText)
                        .lineLimit(3)
                    
                    HStack {
                        Text("\(Int(topic.progress * 100))% Complete")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColorTheme.tertiaryText)
                        
                        Spacer()
                        
                        // Topic color indicator
                        Circle()
                            .fill(topicColor)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            )
                    }
                }
            }
            .padding()
            .background(topicCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: topicColor.opacity(0.4), radius: 20, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [topicColor.opacity(0.5), topicColor.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: topic.progress)
    }
    
    private var topicCardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
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
                // Subtle color tint overlay
                RoundedRectangle(cornerRadius: 16)
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
    }
}

// MARK: - Paginated Topic Card View
struct PaginatedTopicCardView: View {
    let topic: Topic
    let action: () -> Void
    
    private let cornerRadius: CGFloat = 28
    private var topicColor: Color {
        AppColorTheme.topicColor(for: topic.id)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let colorSwatchHeight = geometry.size.height * 0.52
            
            VStack(alignment: .leading, spacing: 0) {
                // Color Swatch Section
                colorSwatchSection(height: colorSwatchHeight)
                
                // Content Section
                contentSection
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(color: topicColor.opacity(0.4), radius: 20, x: 0, y: 10)
        .onTapGesture { action() }
    }
    
    @ViewBuilder
    private func colorSwatchSection(height: CGFloat) -> some View {
        ZStack {
            // Topic color background
            topicColor
            
            // Gradient overlay for depth
            LinearGradient(
                colors: [.white.opacity(0.2), .clear, .black.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Decorative circles
            GeometryReader { geo in
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: geo.size.width * 0.4, height: geo.size.width * 0.4)
                    .offset(x: -geo.size.width * 0.2, y: -geo.size.height * 0.15)
                
                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: geo.size.width * 0.25, height: geo.size.width * 0.25)
                    .offset(x: geo.size.width * 0.6, y: geo.size.height * 0.5)
            }
            
            // Topic icon overlay
            GeometryReader { geo in
                Image(systemName: AppColorTheme.topicIcon(for: topic.id))
                    .font(.system(size: min(geo.size.width, geo.size.height) * 0.35, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.9),
                                .white.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(height: height)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: cornerRadius,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: cornerRadius
            )
        )
    }
    
    @ViewBuilder
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Description only (title is shown above card)
            Text(topic.description)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("Explore")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(topicColor)
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(topicColor)
                
                Spacer(minLength: 8)
                
                // Circular Progress View
                ZStack {
                    // Background circle (stroke)
                    Circle()
                        .stroke(topicColor.opacity(0.3), lineWidth: 3)
                        .frame(width: 40, height: 40)
                    
                    // Progress fill
                    Circle()
                        .trim(from: 0, to: topic.progress)
                        .stroke(
                            topicColor,
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: topic.progress)
                    
                    // Percentage text
                    Text("\(Int(topic.progress * 100))%")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundStyle(topicColor)
                }
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 40, height: 40)
                )
            }
            .frame(maxWidth: .infinity)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(
                LinearGradient(
                    colors: [Color(white: 0.15), Color(white: 0.08)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

#Preview {
    TopicListView()
        .environment(LearningViewModel())
}
