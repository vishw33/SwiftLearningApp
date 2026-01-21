# Quick Start - Run on Simulator

## Option 1: Run from Xcode (Recommended)

1. **The project should already be open in Xcode**. If not:
   ```bash
   open SwiftLearningApp.xcodeproj
   ```

2. **Select a simulator**:
   - Click the device selector at the top (next to "SwiftLearningApp")
   - Choose any iPhone simulator (iOS 17.0+)

3. **Build and Run**:
   - Press `⌘R` (Command + R)
   - Or click the Play button in the toolbar

## Option 2: Run from Command Line

1. **Set Xcode path** (if needed):
   ```bash
   sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
   ```

2. **Run the script**:
   ```bash
   ./run.sh
   ```

## Option 3: Manual Command Line Build

```bash
# List available simulators
xcrun simctl list devices available

# Build and run (replace DEVICE_ID with actual simulator ID)
xcodebuild -project SwiftLearningApp.xcodeproj \
           -scheme SwiftLearningApp \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 15' \
           clean build run
```

## Troubleshooting

### "xcode-select requires Xcode"
Run: `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`

### "No scheme found"
1. Open project in Xcode
2. Product > Scheme > Manage Schemes
3. Check "SwiftLearningApp" scheme

### "Resource files not found"
1. In Xcode, select all JSON files in `Resources/` folder
2. File Inspector (⌘⌥1)
3. Check "Target Membership: SwiftLearningApp"

### Build Errors
- Ensure iOS 17.0+ deployment target is set
- Check all Swift files are added to target
- Verify JSON resources are in bundle

## First Time Setup

If this is your first time:

1. **Open the project**: `open SwiftLearningApp.xcodeproj`
2. **Wait for indexing** to complete (watch progress bar)
3. **Select simulator**: Choose iPhone 15 or later (iOS 17+)
4. **Build**: Press `⌘B` to build first
5. **Run**: Press `⌘R` to run

The app will launch on the simulator automatically!
