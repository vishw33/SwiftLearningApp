//
//  StatCardView.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

/// A card view that displays a statistic with an icon and value.
///
/// This view is used to show progress statistics like topics completed
/// or total topics in a visually appealing card format.
struct StatCardView: View {
    /// The title text to display below the value.
    let title: String
    
    /// The value to display prominently.
    let value: String
    
    /// The SF Symbol name for the icon.
    let icon: String
    
    /// The color for the icon.
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .primaryTextStyle()
            
            Text(title)
                .font(.system(size: 14, weight: .regular))
                .secondaryTextStyle()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}
