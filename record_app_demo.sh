#!/bin/bash

# Script to build, launch, and prepare for app demo recording
# After running this script, use QuickTime Player to record the screen

echo "🎬 SwiftLearningApp Demo Recording Setup"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: List available simulators
echo -e "${BLUE}📱 Available iOS Simulators:${NC}"
xcrun simctl list devices available | grep -i "iphone" | head -5

# Step 2: Get the first available iPhone simulator
DEVICE=$(xcrun simctl list devices available | grep -i "iphone" | grep -i "15" | head -1 | sed 's/.*(\(.*\))/\1/' | tr -d ' ')
if [ -z "$DEVICE" ]; then
    DEVICE=$(xcrun simctl list devices available | grep -i "iphone" | head -1 | sed 's/.*(\(.*\))/\1/' | tr -d ' ')
fi

if [ -z "$DEVICE" ]; then
    echo -e "${YELLOW}⚠️  No iPhone simulator found. Please create one in Xcode.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Using device: $DEVICE${NC}"
echo ""

# Step 3: Boot the simulator
echo -e "${BLUE}🚀 Booting simulator...${NC}"
xcrun simctl boot "$DEVICE" 2>/dev/null || echo "Simulator already booted"

# Step 4: Open Simulator app
echo -e "${BLUE}📲 Opening Simulator app...${NC}"
open -a Simulator

# Wait for simulator to be ready
echo -e "${BLUE}⏳ Waiting for simulator to be ready...${NC}"
sleep 5

# Step 5: Build the app
echo -e "${BLUE}🔨 Building app...${NC}"
xcodebuild -project SwiftLearningApp.xcodeproj \
    -scheme SwiftLearningApp \
    -sdk iphonesimulator \
    -destination "platform=iOS Simulator,id=$DEVICE" \
    clean build 2>&1 | grep -E "(error|warning|succeeded|failed)" | tail -10

BUILD_RESULT=$?

if [ $BUILD_RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ Build successful!${NC}"
else
    echo -e "${YELLOW}⚠️  Build completed with warnings/errors. Check output above.${NC}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}📹 Recording Instructions:${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "1. Open QuickTime Player (Applications > QuickTime Player)"
echo "2. Go to File > New Screen Recording"
echo "3. Click the Record button"
echo "4. Select the Simulator window"
echo ""
echo -e "${YELLOW}📋 Demo Flow (30 seconds):${NC}"
echo ""
echo "  0-5s:   Topics List (Grid view) - Show topic cards"
echo "  5-8s:   Switch to Paginated view - Swipe through topics"
echo "  8-12s:  Tap a topic → Topic Detail view - Show sections"
echo "  12-16s: Scroll to Code Examples - Tap a code example"
echo "  16-20s: Code Example view - Show code with annotations"
echo "  20-24s: Back to Topic Detail → Tap 'Start Quiz'"
echo "  24-28s: Quiz view - Answer a question, show progress"
echo "  28-30s: Progress tab - Show overall stats and achievements"
echo ""
echo -e "${BLUE}💡 Tips:${NC}"
echo "- Keep transitions smooth and quick"
echo "- Focus on key features in each view"
echo "- Show the layout toggle and different views"
echo "- Highlight the modern UI design"
echo ""
echo -e "${GREEN}✅ Simulator is ready! Start recording when ready.${NC}"
