# 📹 30-Second App Demo Script

## Quick Start

Run the setup script:
```bash
./record_app_demo.sh
```

Then follow the recording instructions.

## 🎬 30-Second Demo Flow

### Timeline Breakdown

| Time | Action | View/Feature |
|------|--------|--------------|
| **0-5s** | Show Topics List | Grid layout with topic cards, progress bars, completion badges |
| **5-8s** | Switch Layout | Tap layout toggle → Paginated view, swipe through topics |
| **8-12s** | Open Topic Detail | Tap a topic card → Show topic title, description, sections |
| **12-16s** | View Code Examples | Scroll down, tap a code example card |
| **16-20s** | Code Example View | Show code with syntax highlighting, annotations |
| **20-24s** | Start Quiz | Navigate back, tap "Start Quiz" button |
| **24-28s** | Quiz Interface | Show question, select answer, show progress bar |
| **28-30s** | Progress Tab | Switch to Progress tab, show stats and achievements |

## 📱 Features to Highlight

### Topics View
- ✅ Grid and Paginated layout toggle
- ✅ Topic cards with progress indicators
- ✅ Completion badges
- ✅ Smooth animations

### Topic Detail
- ✅ Topic sections with content
- ✅ Code examples list
- ✅ Modern card design

### Code Examples
- ✅ Syntax highlighting
- ✅ Annotations
- ✅ Before/After toggle (for migration examples)

### Quiz
- ✅ Question display
- ✅ Answer selection
- ✅ Progress tracking
- ✅ Navigation between questions

### Progress
- ✅ Overall statistics
- ✅ Topic progress bars
- ✅ Achievements display

## 🎥 Recording Tips

1. **Use QuickTime Player** (built into macOS)
   - File → New Screen Recording
   - Select the Simulator window
   - Record in full quality

2. **Keep it Smooth**
   - Pre-plan your taps and swipes
   - Keep transitions quick (1-2 seconds each)
   - Don't pause too long on any screen

3. **Show Key Features**
   - Layout toggle functionality
   - Progress indicators
   - Modern UI design
   - Smooth animations

4. **Editing (Optional)**
   - Trim to exactly 30 seconds
   - Add text overlays if needed
   - Speed up slow transitions (1.2x if needed)

## 🛠️ Alternative: Automated Recording

If you want to automate the demo, you can use:

```bash
# Install ffmpeg if needed
brew install ffmpeg

# Record simulator screen
xcrun simctl io booted recordVideo demo.mp4
```

Then manually navigate through the app while recording.

## 📝 Manual Steps (if script doesn't work)

1. Open Xcode
2. Select iPhone 15 Simulator
3. Build and Run (Cmd+R)
4. Open QuickTime Player
5. File → New Screen Recording
6. Follow the demo flow above
