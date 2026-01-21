#!/bin/bash
# Script to build and run SwiftLearningApp on simulator

echo "🚀 Swift Learning App - Build & Run Script"
echo "=========================================="
echo ""

# Check if Xcode is set up
if ! xcode-select -p | grep -q "Xcode.app"; then
    echo "⚠️  Setting Xcode developer directory..."
    echo "Please enter your password to set Xcode path:"
    sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
fi

# Get available simulators
echo "📱 Available iOS Simulators:"
xcrun simctl list devices available | grep "iPhone" | head -5
echo ""

# Get first available iPhone simulator
SIMULATOR=$(xcrun simctl list devices available | grep "iPhone" | grep -v "unavailable" | head -1 | sed 's/.*(\(.*\))/\1/' | sed 's/).*//')

if [ -z "$SIMULATOR" ]; then
    echo "❌ No available iPhone simulator found"
    echo "Please create a simulator in Xcode: Window > Devices and Simulators"
    exit 1
fi

echo "🎯 Using simulator: $SIMULATOR"
echo ""

# Build the project
echo "🔨 Building project..."
cd "$(dirname "$0")"
xcodebuild -project SwiftLearningApp.xcodeproj \
           -scheme SwiftLearningApp \
           -sdk iphonesimulator \
           -destination "platform=iOS Simulator,id=$SIMULATOR" \
           clean build 2>&1 | grep -E "(error|warning|succeeded|failed)" | tail -5

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "🚀 Launching app on simulator..."
    xcrun simctl boot "$SIMULATOR" 2>/dev/null
    xcodebuild -project SwiftLearningApp.xcodeproj \
               -scheme SwiftLearningApp \
               -sdk iphonesimulator \
               -destination "platform=iOS Simulator,id=$SIMULATOR" \
               run
else
    echo ""
    echo "❌ Build failed. Please check errors above."
    echo "💡 Tip: Open the project in Xcode and build from there (⌘R)"
    exit 1
fi
