#!/bin/bash

# Quick script to open app and start QuickTime recording

echo "🎬 Quick Recording Setup"
echo "========================"
echo ""

# Open project in Xcode
echo "📂 Opening Xcode project..."
open SwiftLearningApp.xcodeproj

sleep 2

# Open QuickTime
echo "📹 Opening QuickTime Player..."
open -a "QuickTime Player"

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. In Xcode: Select iPhone 15 Simulator and press ⌘R to run"
echo "2. In QuickTime: File > New Screen Recording"
echo "3. Click Record button, then click on Simulator window"
echo "4. Navigate through the app following the demo flow"
echo "5. Stop recording after 30 seconds"
echo ""
echo "💡 Tip: Pre-plan your taps for smooth 30-second demo!"
