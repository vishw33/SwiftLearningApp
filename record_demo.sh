#!/bin/bash

# Script to build app and prepare for 30-second demo recording

echo "🎬 SwiftLearningApp - Demo Recording Setup"
echo "=========================================="
echo ""

# Set Xcode path if needed
if ! xcode-select -p | grep -q "Xcode.app"; then
    echo "⚠️  Setting Xcode developer directory..."
    sudo xcode-select -s /Applications/Xcode.app/Contents/Developer 2>/dev/null || true
fi

# Get simulator
SIMULATOR=$(xcrun simctl list devices available 2>/dev/null | grep "iPhone" | grep -v "unavailable" | head -1 | sed 's/.*(\(.*\))/\1/' | sed 's/).*//')

if [ -z "$SIMULATOR" ]; then
    echo "❌ No simulator found. Opening Xcode..."
    open SwiftLearningApp.xcodeproj
    echo ""
    echo "Please:"
    echo "1. Select a simulator in Xcode"
    echo "2. Build and run (⌘R)"
    echo "3. Then use QuickTime to record"
    exit 0
fi

echo "📱 Using simulator: $SIMULATOR"
echo ""

# Build and launch
echo "🔨 Building app..."
xcodebuild -project SwiftLearningApp.xcodeproj \
    -scheme SwiftLearningApp \
    -sdk iphonesimulator \
    -destination "platform=iOS Simulator,id=$SIMULATOR" \
    clean build 2>&1 | grep -E "(BUILD|error|warning)" | tail -3

echo ""
echo "🚀 Launching app..."
xcrun simctl boot "$SIMULATOR" 2>/dev/null
open -a Simulator

sleep 3

xcodebuild -project SwiftLearningApp.xcodeproj \
    -scheme SwiftLearningApp \
    -sdk iphonesimulator \
    -destination "platform=iOS Simulator,id=$SIMULATOR" \
    run > /dev/null 2>&1 &

echo ""
echo "✅ App is launching!"
echo ""
echo "📹 RECORDING INSTRUCTIONS:"
echo "=========================="
echo ""
echo "1. Open QuickTime Player (Applications > QuickTime Player)"
echo "2. File > New Screen Recording"
echo "3. Click the Record button"
echo "4. Click on the Simulator window"
echo ""
echo "⏱️  30-SECOND DEMO FLOW:"
echo "   • 0-5s:   Topics grid view"
echo "   • 5-8s:   Switch to paginated view"
echo "   • 8-12s:  Open topic detail"
echo "   • 12-16s: View code examples"
echo "   • 16-20s: Open code example"
echo "   • 20-24s: Start quiz"
echo "   • 24-28s: Answer question"
echo "   • 28-30s: Show progress tab"
echo ""
echo "Press Ctrl+C when done, or let it run..."
