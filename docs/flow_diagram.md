# 🔄 Flow Diagram - SwiftLearningApp

## Application Flow

```mermaid
flowchart TD
    Start([App Launch]) --> ContentView[ContentView]
    
    ContentView --> Tab1[Topics Tab]
    ContentView --> Tab2[Progress Tab]
    ContentView --> Tab3[Challenges Tab]
    
    %% Topics Tab Flow
    Tab1 --> TopicList[TopicListView]
    TopicList --> CheckLoading{Loading?}
    CheckLoading -->|Yes| LoadingView[Loading View]
    CheckLoading -->|No| CheckError{Error?}
    CheckError -->|Yes| ErrorView[Error View]
    CheckError -->|No| CheckEmpty{Empty?}
    CheckEmpty -->|Yes| EmptyView[Empty View]
    CheckEmpty -->|No| LayoutChoice{Layout Type?}
    
    LayoutChoice -->|Grid| GridView[Grid Layout]
    LayoutChoice -->|Paginated| PaginatedView[Paginated Layout]
    
    GridView --> TopicCard[TopicCardView]
    PaginatedView --> PaginatedCard[PaginatedTopicCardView]
    
    TopicCard --> TopicDetail[TopicDetailView]
    PaginatedCard --> TopicDetail
    
    %% Topic Detail Flow
    TopicDetail --> Sections[Topic Sections]
    TopicDetail --> CodeExamples[Code Examples List]
    TopicDetail --> QuizButton[Start Quiz Button]
    
    CodeExamples --> CodeExampleView[CodeExampleView]
    CodeExampleView --> CodeDisplay[Code Display]
    CodeExampleView --> Annotations[Annotations View]
    
    QuizButton --> QuizView[QuizView]
    
    %% Quiz Flow
    QuizView --> CheckQuizLoading{Loading?}
    CheckQuizLoading -->|Yes| QuizLoading[Loading]
    CheckQuizLoading -->|No| CheckResults{Show Results?}
    CheckResults -->|Yes| QuizResults[QuizResultsView]
    CheckResults -->|No| QuestionView[QuestionView]
    
    QuestionView --> AnswerOptions[Answer Options]
    QuestionView --> NavigationButtons[Navigation Buttons]
    
    AnswerOptions --> SubmitAnswer[Submit Answer]
    SubmitAnswer --> CheckLast{Last Question?}
    CheckLast -->|Yes| FinishButton[Finish Quiz]
    CheckLast -->|No| NextButton[Next Question]
    
    NextButton --> QuestionView
    FinishButton --> CalculateScore[Calculate Score]
    CalculateScore --> QuizResults
    
    QuizResults --> ReviewAnswers[Review Answers]
    QuizResults --> DoneButton[Done Button]
    DoneButton --> UpdateProgress[Update Progress]
    UpdateProgress --> TopicList
    
    %% Progress Tab Flow
    Tab2 --> ProgressView[ProgressView]
    ProgressView --> OverallStats[Overall Stats]
    ProgressView --> TopicProgress[Topic Progress List]
    ProgressView --> Achievements[Achievements List]
    
    %% Challenges Tab Flow
    Tab3 --> WebQuestionsView[WebQuestionsView]
    WebQuestionsView --> CheckWebLoading{Loading?}
    CheckWebLoading -->|Yes| WebLoading[Loading]
    CheckWebLoading -->|No| QuestionsList[Questions List]
    
    QuestionsList --> WebQuestionCard[WebQuestionCardView]
    WebQuestionCard --> WebQuestionDetail[WebQuestionDetailView]
    
    WebQuestionDetail --> QuestionContent[Question Content]
    WebQuestionDetail --> CodeSnippet[Code Snippet]
    WebQuestionDetail --> SolutionToggle[Solution Toggle]
    SolutionToggle --> SolutionView[Solution View]
    
    %% Styling
    classDef viewClass fill:#4A90E2,stroke:#2E5C8A,color:#fff
    classDef decisionClass fill:#F5A623,stroke:#D68910,color:#fff
    classDef actionClass fill:#7ED321,stroke:#5BA317,color:#fff
    
    class ContentView,TopicListView,TopicDetailView,QuizView,ProgressView,WebQuestionsView viewClass
    class CheckLoading,CheckError,CheckEmpty,LayoutChoice,CheckQuizLoading,CheckResults,CheckLast,CheckWebLoading decisionClass
    class SubmitAnswer,CalculateScore,UpdateProgress actionClass
```

## User Journey Flow

### 1. App Launch → Topics List
```
App Launch
  ↓
ContentView (TabView)
  ↓
Topics Tab (Default)
  ↓
TopicListView
  ↓
Load Topics (async)
  ↓
Display Grid/Paginated Layout
```

### 2. Topic Selection → Detail View
```
User Taps Topic Card
  ↓
TopicDetailView
  ↓
Load Code Examples (async)
  ↓
Display Sections + Code Examples
```

### 3. Quiz Flow
```
User Taps "Start Quiz"
  ↓
QuizView
  ↓
Load Questions (async)
  ↓
QuestionView (First Question)
  ↓
User Selects Answer
  ↓
Submit Answer → Store
  ↓
Next Question (or Finish)
  ↓
Calculate Score
  ↓
QuizResultsView
  ↓
Update Progress
  ↓
Return to Topics
```

### 4. Progress Tracking
```
User Switches to Progress Tab
  ↓
ProgressView
  ↓
Load User Progress
  ↓
Display Stats + Topic Progress + Achievements
```

### 5. Challenges Flow
```
User Switches to Challenges Tab
  ↓
WebQuestionsView
  ↓
Fetch Tough Questions (async)
  ↓
Display Question Cards
  ↓
User Taps Question
  ↓
WebQuestionDetailView
  ↓
Show Question + Solution Toggle
```

## State Management Flow

```mermaid
stateDiagram-v2
    [*] --> Initializing
    Initializing --> Loading: loadTopics()
    Loading --> Loaded: Success
    Loading --> Error: Failure
    Error --> Loading: Retry
    Loaded --> TopicSelected: User selects topic
    TopicSelected --> TopicDetail: Navigate
    TopicDetail --> QuizStarted: Start quiz
    QuizStarted --> QuizInProgress: Answer questions
    QuizInProgress --> QuizCompleted: Finish quiz
    QuizCompleted --> ProgressUpdated: Save progress
    ProgressUpdated --> Loaded: Return to list
    TopicDetail --> CodeExampleView: View code
    CodeExampleView --> TopicDetail: Back
    Loaded --> [*]
```

## Data Flow Architecture

```mermaid
sequenceDiagram
    participant U as User
    participant V as View
    participant VM as ViewModel
    participant S as Service
    participant M as Model
    
    U->>V: Tap Topic
    V->>VM: startTopic(topic)
    VM->>V: Update state
    V->>V: Navigate to Detail
    
    U->>V: Start Quiz
    V->>VM: loadQuestions()
    VM->>S: loadQuestions(topicId)
    S->>M: Load from JSON
    M-->>S: Return Questions
    S-->>VM: Return Questions
    VM->>VM: Update questions array
    VM->>V: Trigger update
    V->>V: Show QuestionView
    
    U->>V: Submit Answer
    V->>VM: submitAnswer(id, answer)
    VM->>VM: Store in userAnswers
    U->>V: Finish Quiz
    V->>VM: finishQuiz()
    VM->>VM: calculateScore()
    VM->>S: completeQuiz(score, topicId)
    S->>M: Update LearningProgress
    M-->>S: Progress saved
    S-->>VM: Success
    VM->>V: Show results
```
