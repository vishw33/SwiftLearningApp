//
//  ColorTheme.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import SwiftUI

struct AppColorTheme {
    // MARK: - Exotic Colors
    static let exoticPurple = Color(red: 0.6, green: 0.2, blue: 0.9)
    static let exoticCyan = Color(red: 0.0, green: 0.8, blue: 1.0)
    static let exoticMagenta = Color(red: 1.0, green: 0.2, blue: 0.6)
    static let exoticAmber = Color(red: 1.0, green: 0.7, blue: 0.0)
    static let exoticEmerald = Color(red: 0.0, green: 0.8, blue: 0.4)
    static let exoticIndigo = Color(red: 0.4, green: 0.2, blue: 1.0)
    static let exoticRose = Color(red: 1.0, green: 0.3, blue: 0.5)
    static let exoticTeal = Color(red: 0.0, green: 0.6, blue: 0.7)
    
    // MARK: - Dark Theme Colors
    static let darkBackground = Color(red: 0.05, green: 0.05, blue: 0.1)
    static let darkSurface = Color(red: 0.1, green: 0.1, blue: 0.15)
    static let darkElevated = Color(red: 0.15, green: 0.12, blue: 0.18)
    
    // MARK: - Accent Colors
    static let primaryAccent = exoticPurple
    static let secondaryAccent = exoticCyan
    static let successColor = exoticEmerald
    static let warningColor = exoticAmber
    static let errorColor = exoticRose
    
    // MARK: - Text Colors
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let tertiaryText = Color.white.opacity(0.6)
    
    // MARK: - Topic-Specific Colors (inspired by Animation project)
    static func topicColor(for topicId: String) -> Color {
        switch topicId {
        case "async-await":
            return Color(red: 0.0, green: 0.8, blue: 1.0) // Cyan
        case "swift6-migration":
            return Color(red: 0.6, green: 0.2, blue: 0.9) // Purple
        case "concurrency":
            return Color(red: 1.0, green: 0.2, blue: 0.6) // Magenta
        case "common-mistakes":
            return Color(red: 1.0, green: 0.3, blue: 0.5) // Rose
        case "swift-basics":
            return Color(red: 0.0, green: 0.6, blue: 0.7) // Teal
        case "access-specifiers":
            return Color(red: 0.4, green: 0.2, blue: 1.0) // Indigo
        case "dynamic-library":
            return Color(red: 0.0, green: 0.8, blue: 0.4) // Emerald
        case "static-library":
            return Color(red: 1.0, green: 0.7, blue: 0.0) // Amber
        case "closures":
            return Color(red: 0.98, green: 0.45, blue: 0.02) // Sunset Orange
        case "memory-management":
            return Color(red: 0.86, green: 0.08, blue: 0.24) // Crimson Red
        case "dispatch-queue":
            return Color(red: 0.0, green: 0.45, blue: 0.74) // Ocean Blue
        case "threading":
            return Color(red: 0.13, green: 0.55, blue: 0.13) // Forest Green
        case "serial-concurrent-sync-async":
            return Color(red: 0.19, green: 0.84, blue: 0.78) // Turquoise
        case "avkit":
            return Color(red: 1.0, green: 0.41, blue: 0.71) // Hot Pink
        case "observable-observableobject":
            return Color(red: 0.48, green: 0.12, blue: 0.64) // Royal Purple
        default:
            return exoticCyan // Default fallback
        }
    }
    
    // MARK: - Topic Icons Mapping
    static func topicIcon(for topicId: String) -> String {
        switch topicId {
        case "asyncAwait", "async-await":
            return "bolt.fill"
        case "swift6Migration", "swift6-migration":
            return "arrow.triangle.2.circlepath"
        case "commonMistakes", "common-mistakes":
            return "exclamationmark.triangle.fill"
        case "concurrency":
            return "cpu.fill"
        case "swiftBasics", "swift-basics":
            return "swift"
        case "accessSpecifiers", "access-specifiers":
            return "lock.shield.fill"
        case "dynamicLibrary", "dynamic-library":
            return "square.stack.3d.up.fill"
        case "staticLibrary", "static-library":
            return "square.stack.3d.down.fill"
        case "closures":
            return "curlybraces"
        case "memoryManagement", "memory-management":
            return "memorychip.fill"
        case "dispatchQueue", "dispatch-queue":
            return "list.bullet.rectangle.fill"
        case "threading":
            return "thread"
        case "serialConcurrentSyncAsync", "serial-concurrent-sync-async":
            return "arrow.triangle.branch"
        case "avkit":
            return "play.rectangle.fill"
        case "observableObservableObject", "observable-observableobject":
            return "eye.fill"
        default:
            return "book.fill"
        }
    }
    
    // MARK: - Smooth Gradient Background
    static var smoothGradientBackground: some View {
        ZStack {
            // Base dark gradient
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.08, blue: 0.12),
                    Color(red: 0.12, green: 0.10, blue: 0.16),
                    Color(red: 0.10, green: 0.10, blue: 0.14)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Subtle radial overlays for depth
            RadialGradient(
                colors: [
                    Color(red: 0.2, green: 0.1, blue: 0.3).opacity(0.3),
                    Color.clear
                ],
                center: .topLeading,
                startRadius: 0,
                endRadius: 600
            )
            
            RadialGradient(
                colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.3).opacity(0.2),
                    Color.clear
                ],
                center: .bottomTrailing,
                startRadius: 0,
                endRadius: 500
            )
        }
    }
    
    // MARK: - Mesh Gradients (iOS 18+)
    @available(iOS 18.0, *)
    static var meshGradientBackground: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                .init(0.0, 0.0), .init(0.5, 0.0), .init(1.0, 0.0),
                .init(0.0, 0.5), .init(0.5, 0.5), .init(1.0, 0.5),
                .init(0.0, 1.0), .init(0.5, 1.0), .init(1.0, 1.0)
            ],
            colors: [
                exoticIndigo, exoticPurple, exoticMagenta,
                exoticCyan, darkBackground, exoticRose,
                exoticTeal, exoticEmerald, exoticAmber
            ]
        )
    }
    
    // Fallback gradient for older iOS versions
    static var fallbackGradientBackground: some View {
        ZStack {
            LinearGradient(
                colors: [exoticIndigo, exoticPurple, exoticMagenta],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            RadialGradient(
                colors: [exoticCyan.opacity(0.3), Color.clear],
                center: .center,
                startRadius: 0,
                endRadius: 500
            )
        }
    }
    
    @available(iOS 18.0, *)
    static var meshGradientCard: some View {
        MeshGradient(
            width: 2,
            height: 2,
            points: [
                .init(0.0, 0.0), .init(1.0, 0.0),
                .init(0.0, 1.0), .init(1.0, 1.0)
            ],
            colors: [
                exoticPurple.opacity(0.3),
                exoticCyan.opacity(0.3),
                exoticMagenta.opacity(0.3),
                exoticIndigo.opacity(0.3)
            ]
        )
    }
    
    static var fallbackGradientCard: some View {
        LinearGradient(
            colors: [
                exoticPurple.opacity(0.3),
                exoticCyan.opacity(0.3),
                exoticMagenta.opacity(0.3)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    @available(iOS 18.0, *)
    static var meshGradientAccent: some View {
        MeshGradient(
            width: 2,
            height: 2,
            points: [
                .init(0.0, 0.0), .init(1.0, 0.0),
                .init(0.0, 1.0), .init(1.0, 1.0)
            ],
            colors: [
                exoticPurple,
                exoticCyan,
                exoticMagenta,
                exoticIndigo
            ]
        )
    }
    
    static var fallbackGradientAccent: some View {
        LinearGradient(
            colors: [exoticPurple, exoticCyan, exoticMagenta],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
}

// MARK: - Swift Default Color (for headers/nav titles)
extension Color {
    static var swiftDefault: Color {
        // Swift's default accent color (system blue)
        return .accentColor
    }
}

// MARK: - View Modifiers
struct CardStyle: ViewModifier {
    let hasGlow: Bool
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    if #available(iOS 18.0, *) {
                        AppColorTheme.meshGradientCard
                    } else {
                        AppColorTheme.fallbackGradientCard
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            hasGlow ? AppColorTheme.exoticCyan.opacity(0.4) : AppColorTheme.exoticCyan.opacity(0.3),
                            lineWidth: hasGlow ? 2 : 1.5
                        )
                )
            )
            .shadow(
                color: hasGlow ? AppColorTheme.exoticPurple.opacity(0.3) : .black.opacity(0.3),
                radius: hasGlow ? 15 : 10,
                x: 0,
                y: hasGlow ? 8 : 5
            )
    }
}

struct ElevatedCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColorTheme.exoticPurple.opacity(0.2), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.4), radius: 15, x: 0, y: 8)
    }
}

extension View {
    func cardStyle(hasGlow: Bool = false) -> some View {
        modifier(CardStyle(hasGlow: hasGlow))
    }
    
    func elevatedCardStyle() -> some View {
        modifier(ElevatedCardStyle())
    }
}
