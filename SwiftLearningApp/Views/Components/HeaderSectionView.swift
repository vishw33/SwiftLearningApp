//
//  HeaderSectionView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A header view that displays the app title and subtitle.
///
/// This view provides a consistent header section for topic lists
/// with the app branding and description.
struct HeaderSectionView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Swift 6 Essentials")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .primaryTextStyle()
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity)
            
            Text("Master async/await, concurrency, and modern Swift")
                .font(.system(size: 16, weight: .regular))
                .secondaryTextStyle()
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
