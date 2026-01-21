#!/bin/bash
# Create Xcode project using xcodebuild or open in Xcode

# Try to open the directory in Xcode - this will prompt to create a project
open -a Xcode /Users/vishwasng/Desktop/Animation/SwiftLearningApp/SwiftLearningApp

echo "If Xcode opened, please:"
echo "1. Create a new project: File > New > Project"
echo "2. Choose iOS > App"
echo "3. Name: SwiftLearningApp"
echo "4. Interface: SwiftUI"
echo "5. Language: Swift"
echo "6. Save in: /Users/vishwasng/Desktop/Animation/SwiftLearningApp/"
echo ""
echo "Then replace the generated SwiftLearningApp folder with our existing one."
