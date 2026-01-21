//
//  CodeExampleView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

struct CodeExampleView: View {
    @Environment(\.dismiss) private var dismiss
    let example: CodeExample
    @Bindable var viewModel: CodeExampleViewModel
    @State private var showExplanation = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Smooth gradient background
                AppColorTheme.smoothGradientBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Title and description
                        VStack(alignment: .leading, spacing: 12) {
                            Text(example.title)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(AppColorTheme.primaryText)
                                .shadow(color: AppColorTheme.exoticPurple.opacity(0.5), radius: 10, x: 0, y: 0)
                            
                            Text(example.description)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(AppColorTheme.secondaryText)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Before/After toggle for migration examples
                        if example.isMigrationExample {
                            Picker("View", selection: $viewModel.showBeforeCode) {
                                Text("Before (Swift 5)").tag(true)
                                Text("After (Swift 6)").tag(false)
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal)
                        }
                        
                        // Code display
                        CodeDisplayView(
                            code: viewModel.getDisplayCode(for: example),
                            annotations: example.annotations
                        )
                        .padding(.horizontal)
                        
                        // Annotations
                        if !example.annotations.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Annotations")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(AppColorTheme.primaryText)
                                    .padding(.horizontal)
                                
                                ForEach(example.annotations) { annotation in
                                    AnnotationView(annotation: annotation)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Code Example")
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
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        UIPasteboard.general.string = viewModel.getDisplayCode(for: example)
                    }) {
                        Image(systemName: "doc.on.doc")
                    }
                }
            }
        }
    }
}

struct CodeDisplayView: View {
    let code: String
    let annotations: [CodeAnnotation]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView(.horizontal, showsIndicators: true) {
                ScrollView(.vertical, showsIndicators: true) {
                    Text(code)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
            .frame(minHeight: 300, maxHeight: 600)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColorTheme.exoticCyan.opacity(0.3), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
        }
    }
}

struct AnnotationView: View {
    let annotation: CodeAnnotation
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(annotation.lineNumber)")
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(AppColorTheme.exoticCyan)
                .frame(width: 40, alignment: .trailing)
            
            Text(annotation.text)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(AppColorTheme.secondaryText)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .elevatedCardStyle()
        .padding(.horizontal)
    }
}

#Preview {
    CodeExampleView(
        example: CodeExample(
            id: "test",
            title: "Test Example",
            description: "Test description",
            code: "print(\"Hello\")",
            relatedTopicId: "test"
        ),
        viewModel: CodeExampleViewModel()
    )
}
