# Swift Learning App

An interactive iOS app that teaches Swift 6 essentials, focusing on async/await, concurrency, Swift 6 migration, and the @Observable macro.

## Features

- **Topic-Based Learning**: Four comprehensive topics covering:
  - Async/Await - Swift 6 Migration
  - Swift 6 Migration Measures
  - Common Mistakes & Errors
  - Concurrency Handling (Latest)

- **Interactive Q&A Quiz System**: Multiple question types including:
  - Multiple choice
  - True/False
  - Code completion
  - Bug identification
  - Migration scenarios

- **Code Examples**: Comprehensive code examples with:
  - Syntax highlighting
  - Before/After migration comparisons
  - Inline annotations and explanations
  - Copy-to-clipboard functionality

- **Progress Tracking**: Track your learning progress with:
  - Topic completion status
  - Quiz scores and attempts
  - Time spent per module
  - Achievement badges

- **Tough Questions**: Curated challenging questions from the Swift community

## Setup Instructions

### 1. Create Xcode Project

1. Open Xcode
2. Create a new project:
   - Choose "iOS" → "App"
   - Product Name: `SwiftLearningApp`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Minimum Deployment: `iOS 17.0` (required for @Observable)

### 2. Add Files to Project

Add all files from the `SwiftLearningApp` directory to your Xcode project:

```
SwiftLearningApp/
├── SwiftLearningApp.swift
├── Models/
│   ├── Topic.swift
│   ├── Question.swift
│   ├── CodeExample.swift
│   ├── LearningProgress.swift
│   └── WebQuestion.swift
├── ViewModels/
│   ├── LearningViewModel.swift
│   ├── QuizViewModel.swift
│   └── CodeExampleViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── TopicListView.swift
│   ├── TopicDetailView.swift
│   ├── QuizView.swift
│   ├── CodeExampleView.swift
│   ├── ProgressView.swift
│   └── WebQuestionsView.swift
├── Services/
│   ├── ContentService.swift
│   ├── ProgressService.swift
│   └── WebQuestionService.swift
├── Utilities/
│   ├── CodeHighlighter.swift
│   └── MigrationHelper.swift
└── Resources/
    ├── Topics/
    │   ├── asyncAwait.json
    │   ├── swift6Migration.json
    │   ├── commonMistakes.json
    │   └── concurrency.json
    ├── Questions/
    │   └── quizQuestions.json
    └── codeExamples.json
```

### 3. Add Resources to Bundle

**Important**: The JSON resource files must be added to the app bundle:

1. In Xcode, select the `Resources` folder
2. Right-click → "Add Files to SwiftLearningApp"
3. Select all JSON files in:
   - `Resources/Topics/` (4 files)
   - `Resources/Questions/` (1 file)
   - `Resources/` (1 file: codeExamples.json)
4. Make sure "Copy items if needed" is checked
5. Make sure "Add to targets: SwiftLearningApp" is selected

### 4. Configure Project Settings

1. Set Minimum Deployment to **iOS 17.0**
2. Enable Swift 6 language mode (if available in your Xcode version):
   - Build Settings → Swift Language Version → Swift 6
3. Ensure all files are added to the target

### 5. Build and Run

1. Select a simulator or device (iOS 17.0+)
2. Build the project (⌘B)
3. Run the app (⌘R)

## Project Structure

### Models
- `Topic`: Learning topic with sections and content
- `Question`: Quiz questions with multiple types
- `CodeExample`: Code examples with annotations
- `LearningProgress`: User progress tracking
- `WebQuestion`: Tough questions from web sources

### ViewModels (Using @Observable)
- `LearningViewModel`: Main learning state management
- `QuizViewModel`: Quiz flow and scoring
- `CodeExampleViewModel`: Code example viewing

### Views
- `ContentView`: Main tab-based navigation
- `TopicListView`: Grid of learning topics
- `TopicDetailView`: Topic content and code examples
- `QuizView`: Interactive quiz interface
- `CodeExampleView`: Code viewer with syntax highlighting
- `ProgressView`: Progress dashboard
- `WebQuestionsView`: Tough questions from community

### Services
- `ContentService`: Loads topics, questions, and code examples from JSON
- `ProgressService`: Persists user progress
- `WebQuestionService`: Manages tough questions

## Key Technologies

- **SwiftUI**: Modern declarative UI framework
- **@Observable Macro**: iOS 17+ observation framework (replaces ObservableObject)
- **Async/Await**: Swift 6 structured concurrency
- **NavigationStack**: Modern navigation (iOS 16+)
- **Codable**: JSON parsing for content

## Content Structure

All content is stored in JSON files for easy updates:

- **Topics**: Comprehensive explanations, sections, and references to code examples
- **Questions**: Quiz questions with explanations and difficulty levels
- **Code Examples**: Code snippets with annotations and migration examples

## Customization

### Adding New Topics

1. Create a new JSON file in `Resources/Topics/`
2. Follow the structure of existing topic files
3. Add code examples to `codeExamples.json`
4. Add questions to `quizQuestions.json`
5. Update `ContentService` if needed

### Adding Questions

Edit `Resources/Questions/quizQuestions.json` and add new question objects following the existing structure.

### Modifying Code Examples

Edit `Resources/codeExamples.json` to add or modify code examples.

## Notes

- The app uses `@Observable` macro (iOS 17+) instead of `ObservableObject`
- All ViewModels are marked with `@MainActor` for UI updates
- ContentService uses actors for thread-safe file loading
- Progress is persisted using UserDefaults
- Web questions are currently curated; can be extended to fetch from APIs

## Troubleshooting

### JSON Files Not Loading

- Ensure JSON files are added to the app bundle (see step 3 above)
- Check file names match exactly (case-sensitive)
- Verify JSON syntax is valid

### Build Errors

- Ensure iOS 17.0+ deployment target
- Check all files are added to the target
- Verify Swift language version compatibility

### Runtime Issues

- Check console for error messages
- Verify JSON file paths in ContentService
- Ensure proper async/await usage

## Future Enhancements

- Code playground (editable/runnable code)
- Real-time web question fetching from APIs
- Video explanations integration
- Offline mode with cached content
- Export progress reports
- Community question submissions

## License

This project is created for educational purposes.
