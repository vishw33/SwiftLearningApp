# 🎬 30-Second App Demo Guide

## Quick Start

Run the setup script:
```bash
./quick_record.sh
```

This will open:
- Xcode (to run the app)
- QuickTime Player (to record)

## ⏱️ 30-Second Demo Timeline

### Exact Timing Breakdown

| Time | Action | What to Show |
|------|--------|--------------|
| **0-5s** | Topics List (Grid) | Show 2-3 topic cards with progress bars, completion badges |
| **5-8s** | Layout Toggle | Tap layout button → Switch to paginated view, swipe through 2-3 topics |
| **8-12s** | Topic Detail | Tap a topic card → Show title, description, scroll through 1-2 sections |
| **12-16s** | Code Examples | Scroll down, tap a code example card |
| **16-20s** | Code View | Show code with syntax highlighting, scroll through annotations |
| **20-24s** | Start Quiz | Navigate back, tap "Start Quiz" button |
| **24-28s** | Quiz | Show question, quickly select an answer, show progress bar |
| **28-30s** | Progress Tab | Switch to Progress tab, show stats and achievements |

## 📱 Step-by-Step Recording

### 1. Setup (Before Recording)
- ✅ Xcode is open with project
- ✅ QuickTime Player is open
- ✅ Simulator is ready (iPhone 15 recommended)

### 2. Start Recording
1. In QuickTime: **File → New Screen Recording**
2. Click the **Record** button
3. Click on the **Simulator window** (not the whole screen)
4. Recording starts immediately

### 3. Demo Flow (30 seconds)

**0-5 seconds: Topics Grid**
- App opens on Topics tab
- Show grid layout with topic cards
- Point out progress bars and completion badges
- Smooth pan to show multiple topics

**5-8 seconds: Switch Layout**
- Tap the layout toggle button (top right)
- Switch to paginated view
- Swipe left/right through 2-3 topics
- Show the page indicator dots

**8-12 seconds: Open Topic**
- Tap on a topic card
- Show topic title and description
- Scroll down to show 1-2 content sections
- Highlight the card design

**12-16 seconds: Code Examples**
- Scroll down to "Code Examples" section
- Tap on a code example card
- Show the transition animation

**16-20 seconds: Code View**
- Show code with syntax highlighting
- Scroll through code
- Point out annotations if visible
- Show the modern code display

**20-24 seconds: Quiz**
- Navigate back to topic detail
- Tap "Start Quiz" button
- Show quiz interface loading

**24-28 seconds: Quiz Question**
- Show question text
- Quickly select an answer option
- Show the selection animation
- Point out progress bar

**28-30 seconds: Progress**
- Switch to Progress tab (bottom)
- Show overall stats (topics completed, total)
- Show topic progress bars
- End on achievements section

### 4. Stop Recording
- Press **Stop** button in QuickTime menu bar
- Or press **⌘ + Control + Esc**
- Video saves automatically

## 🎨 Features to Highlight

### Visual Design
- ✅ Modern gradient backgrounds
- ✅ Smooth animations
- ✅ Card-based UI
- ✅ Color-coded topics
- ✅ Progress indicators

### Functionality
- ✅ Layout toggle (Grid ↔ Paginated)
- ✅ Topic navigation
- ✅ Code examples with syntax highlighting
- ✅ Interactive quiz
- ✅ Progress tracking

## 💡 Pro Tips

1. **Practice First**: Run through the demo 2-3 times before recording
2. **Keep It Smooth**: Don't pause too long on any screen
3. **Show Transitions**: Let animations complete before moving on
4. **Focus on Key Features**: Highlight the most impressive features
5. **Timing**: Use a timer or countdown to stay on track

## 🎬 Alternative: Automated Recording

If you want to try automated recording:

```bash
# Install ffmpeg (if not installed)
brew install ffmpeg

# Record simulator (requires simulator to be running)
xcrun simctl io booted recordVideo demo.mp4
```

Then manually navigate through the app. Stop with Ctrl+C.

## 📝 Post-Recording

1. **Trim Video**: Use QuickTime to trim to exactly 30 seconds
   - Edit → Trim
   - Drag handles to 30 seconds

2. **Export**: File → Export As → 1080p (or 4K if needed)

3. **Optional Enhancements**:
   - Add text overlays
   - Add background music
   - Speed up slow parts (1.1x speed)

## 🚀 Ready to Record!

Run `./quick_record.sh` and follow the steps above. Good luck! 🎥
