# Bundle Resource Setup

If topics are not loading, the JSON files may not be included in the app bundle. Follow these steps:

## Steps to Ensure JSON Files are in Bundle

1. **Open the project in Xcode**

2. **Select all JSON files**:
   - In the Project Navigator, expand `SwiftLearningApp` → `Resources`
   - Select all JSON files (Ctrl+Click or Cmd+Click to select multiple):
     - `asyncAwait.json`
     - `swift6Migration.json`
     - `commonMistakes.json`
     - `concurrency.json`
     - `quizQuestions.json`
     - `codeExamples.json`

3. **Check Target Membership**:
   - Open File Inspector (⌘⌥1 or View → Inspectors → File)
   - Under "Target Membership", ensure **SwiftLearningApp** is checked
   - If not checked, check it

4. **Verify Build Phases**:
   - Select the project in Navigator
   - Select the **SwiftLearningApp** target
   - Go to **Build Phases** tab
   - Expand **Copy Bundle Resources**
   - Verify all JSON files are listed there
   - If not, click "+" and add them

5. **Clean and Rebuild**:
   - Product → Clean Build Folder (⇧⌘K)
   - Product → Build (⌘B)

## Alternative: Verify Files are in Bundle

The app now includes debug logging. When you run it, check the Xcode console. You should see:
- `✅ Found asyncAwait.json at: ...`
- `✅ Loaded X topics successfully`

If you see errors, they will list available JSON files in the bundle.

## Quick Fix Script

If files are missing, you can also manually verify:

```bash
# Check what's in the built app bundle
find ~/Library/Developer/Xcode/DerivedData/SwiftLearningApp-*/Build/Products/Debug-iphonesimulator/SwiftLearningApp.app -name "*.json"
```

All 6 JSON files should be present in the app bundle.
