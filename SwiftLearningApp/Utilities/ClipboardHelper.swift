//
//  ClipboardHelper.swift
//  SwiftLearningApp
//
//  Cross-platform clipboard helper for iOS and macOS
//

import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Cross-platform clipboard helper
/// - Note: Provides unified clipboard access for both iOS and macOS
enum ClipboardHelper {
    /// Copies the given string to the system clipboard
    /// - Parameter string: The text to copy
    static func copy(_ string: String) {
        #if os(iOS)
        UIPasteboard.general.string = string
        #elseif os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(string, forType: .string)
        #endif
    }
    
    /// Retrieves the current string from the system clipboard
    /// - Returns: The clipboard string, or nil if not available
    static func paste() -> String? {
        #if os(iOS)
        return UIPasteboard.general.string
        #elseif os(macOS)
        return NSPasteboard.general.string(forType: .string)
        #endif
    }
}
