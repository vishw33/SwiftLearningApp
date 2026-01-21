//
//  CodeBlockView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A view that displays code snippets in a scrollable block.
///
/// This view provides a monospaced font display for code with
/// horizontal and vertical scrolling capabilities.
struct CodeBlockView: View {
    /// The code text to display.
    let code: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.white)
                .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.3))
        )
    }
}
