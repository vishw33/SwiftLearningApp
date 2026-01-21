//
//  WebQuestionService.swift
//  SwiftLearningApp
//
//  Created on 18/01/26.
//

import Foundation

@MainActor
class WebQuestionService {
    static let shared = WebQuestionService()
    
    private let cacheKey = "SwiftLearningApp.WebQuestions"
    private var cachedQuestions: [WebQuestion] = []
    
    private init() {
        loadCachedQuestions()
    }
    
    func fetchToughQuestions() async throws -> [WebQuestion] {
        // In a real implementation, this would fetch from actual APIs
        // For now, we'll return curated tough questions
        // This can be extended to fetch from Reddit API, Stack Overflow API, etc.
        
        let questions = getCuratedToughQuestions()
        cachedQuestions = questions
        saveCachedQuestions(questions)
        return questions
    }
    
    func getCachedQuestions() -> [WebQuestion] {
        return cachedQuestions
    }
    
    nonisolated static func loadCachedQuestionsFromDisk() -> [WebQuestion] {
        let cacheKey = "SwiftLearningApp.WebQuestions"
        if let data = UserDefaults.standard.data(forKey: cacheKey),
           let questions = try? JSONDecoder().decode([WebQuestion].self, from: data) {
            return questions
        }
        return []
    }
    
    private func loadCachedQuestions() {
        if let data = UserDefaults.standard.data(forKey: cacheKey),
           let questions = try? JSONDecoder().decode([WebQuestion].self, from: data) {
            cachedQuestions = questions
        }
    }
    
    private func saveCachedQuestions(_ questions: [WebQuestion]) {
        if let encoded = try? JSONEncoder().encode(questions) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
        }
    }
    
    // Curated tough questions based on real-world scenarios
    private func getCuratedToughQuestions() -> [WebQuestion] {
        return [
            WebQuestion(
                id: "web-1",
                title: "Actor Reentrancy Issue",
                question: "You have an actor that performs async work and then updates its state. What happens if another call to the actor occurs while the first call is suspended?",
                source: "Swift Forums",
                sourceType: "swift-forums",
                difficulty: .hard,
                tags: ["actor", "reentrancy", "concurrency"],
                solution: "Actor methods are reentrant. If a call suspends (e.g., with await), the actor can process other calls. This means you need to be careful about state consistency. Use actor isolation and ensure your state updates are atomic.",
                codeSnippet: """
                actor Counter {
                    var value = 0
                    
                    func increment() async {
                        value += 1
                        await someAsyncOperation()
                        value += 1 // Potential issue: value might have changed
                    }
                }
                """,
                upvotes: 45
            ),
            WebQuestion(
                id: "web-2",
                title: "@Observable with Nested Objects",
                question: "Can you use @Observable on nested objects? What are the limitations?",
                source: "r/swift",
                sourceType: "reddit",
                difficulty: .expert,
                tags: ["@Observable", "swiftui", "observation"],
                solution: "@Observable works best with flat structures. Nested @Observable objects are not fully supported and can lead to observation issues. Prefer composition over nested observables, or use @State for nested objects.",
                codeSnippet: """
                @Observable
                class User {
                    var name: String
                    var profile: Profile? // Profile should NOT be @Observable
                }
                """,
                upvotes: 32
            ),
            WebQuestion(
                id: "web-3",
                title: "Sendable Protocol Violation",
                question: "Why does this code fail to compile in Swift 6, and how do you fix it?",
                source: "Stack Overflow",
                sourceType: "stackoverflow",
                difficulty: .hard,
                tags: ["Sendable", "Swift 6", "concurrency"],
                solution: "Classes are not Sendable by default. You need to either make it a struct (value type), mark it as @unchecked Sendable (if you guarantee thread safety), or use an actor for mutable state.",
                codeSnippet: """
                class DataManager {
                    var data: [String] = []
                }
                
                func process(data: DataManager) async {
                    // Error: 'DataManager' cannot be sent across actors
                }
                """,
                upvotes: 67
            ),
            WebQuestion(
                id: "web-4",
                title: "Task Cancellation Not Working",
                question: "Why doesn't my Task cancel when I call task.cancel()?",
                source: "Swift Forums",
                sourceType: "swift-forums",
                difficulty: .medium,
                tags: ["Task", "cancellation", "async"],
                solution: "Tasks only check for cancellation at suspension points. You need to check Task.isCancelled in loops or use Task.checkCancellation() which throws if cancelled.",
                codeSnippet: """
                let task = Task {
                    for i in 0..<1000000 {
                        // Heavy computation - won't cancel here
                        process(i)
                        // Need to check:
                        try Task.checkCancellation()
                    }
                }
                """,
                upvotes: 28
            ),
            WebQuestion(
                id: "web-5",
                title: "@MainActor Performance Issue",
                question: "My UI is freezing even though I'm using @MainActor. What's wrong?",
                source: "r/swift",
                sourceType: "reddit",
                difficulty: .hard,
                tags: ["@MainActor", "performance", "ui"],
                solution: "@MainActor ensures thread safety but doesn't prevent blocking. If you do heavy computation on @MainActor, it blocks the UI. Move heavy work off the main actor and only update UI properties on @MainActor.",
                codeSnippet: """
                @MainActor
                class ViewModel {
                    var items: [Item] = []
                    
                    func loadData() async {
                        // BAD: Heavy work on main actor
                        items = processLargeDataset() // Blocks UI!
                        
                        // GOOD: Do work off main actor
                        let processed = await Task.detached {
                            processLargeDataset()
                        }.value
                        items = processed
                    }
                }
                """,
                upvotes: 41
            ),
            // Swift Basics - Optionals and Type System
            WebQuestion(
                id: "web-6",
                title: "Optional Chaining with Force Unwrap",
                question: "What's wrong with this code? Why does it crash sometimes but not always?",
                source: "Stack Overflow",
                sourceType: "stackoverflow",
                difficulty: .medium,
                tags: ["optionals", "swift-basics", "force-unwrap"],
                solution: "Using force unwrap (!) after optional chaining defeats the purpose. If any part of the chain is nil, the force unwrap will crash. Use optional binding or nil coalescing instead.",
                codeSnippet: """
                let name = person?.address?.street?.name! // Dangerous!
                
                // Safe alternatives:
                if let name = person?.address?.street?.name {
                    // Use name
                }
                
                let name = person?.address?.street?.name ?? "Unknown"
                """,
                upvotes: 89
            ),
            WebQuestion(
                id: "web-7",
                title: "Value Type Mutation in Closures",
                question: "Why does this code print different values than expected?",
                source: "Swift Forums",
                sourceType: "swift-forums",
                difficulty: .hard,
                tags: ["closures", "value-types", "capture"],
                solution: "Closures capture variables by reference. When you capture a value type variable, you're capturing a reference to the variable, not a copy. Use a capture list to capture by value: [value = variable].",
                codeSnippet: """
                var closures: [() -> Int] = []
                for i in 0..<3 {
                    closures.append { i } // Captures reference to i
                }
                // All closures return 3 (final value)
                
                // Fix: Capture by value
                for i in 0..<3 {
                    closures.append { [i] in i }
                }
                """,
                upvotes: 56
            ),
            // Access Specifiers
            WebQuestion(
                id: "web-8",
                title: "Public vs Open in Framework",
                question: "I created a framework with a public class, but I can't subclass it from my app. Why?",
                source: "r/swift",
                sourceType: "reddit",
                difficulty: .medium,
                tags: ["access-control", "public", "open", "frameworks"],
                solution: "public classes can be used but not subclassed outside the module. Use open for classes that should be subclassable. open is more permissive than public - it allows subclassing and overriding from other modules.",
                codeSnippet: """
                // Framework code
                public class BaseViewController { // Cannot be subclassed
                    public func viewDidLoad() { } // Cannot be overridden
                }
                
                // App code - ERROR
                class MyViewController: BaseViewController { } // ❌
                
                // Fix: Use open in framework
                open class BaseViewController { // Can be subclassed
                    open func viewDidLoad() { } // Can be overridden
                }
                """,
                upvotes: 73
            ),
            WebQuestion(
                id: "web-9",
                title: "Private Setter Pattern",
                question: "How do you make a property readable from outside but only writable from within the type?",
                source: "Stack Overflow",
                sourceType: "stackoverflow",
                difficulty: .medium,
                tags: ["access-control", "private-set", "properties"],
                solution: "Use private(set) to make the setter private while keeping the getter at the default access level. This creates a read-only property from outside the type.",
                codeSnippet: """
                class BankAccount {
                    private(set) var balance: Double = 0.0
                    
                    func deposit(amount: Double) {
                        balance += amount // OK: same class
                    }
                }
                
                let account = BankAccount()
                print(account.balance) // OK: readable
                // account.balance = 100 // ERROR: setter is private
                """,
                upvotes: 45
            ),
            // Dynamic vs Static Libraries
            WebQuestion(
                id: "web-10",
                title: "Choosing Between Dynamic and Static Libraries",
                question: "When should I use a dynamic library vs static library for my Swift package?",
                source: "Swift Forums",
                sourceType: "swift-forums",
                difficulty: .hard,
                tags: ["dynamic-library", "static-library", "swift-package"],
                solution: "Use static libraries for single apps where launch time matters. Use dynamic libraries when you need code sharing across multiple apps/extensions, or when building frameworks for distribution. Static = faster launch, larger binary. Dynamic = smaller binary, shared code, slower launch.",
                codeSnippet: """
                // Package.swift
                .library(
                    name: "MyLib",
                    type: .static, // or .dynamic
                    targets: ["MyLib"]
                )
                
                // Static: Faster launch, code embedded in binary
                // Dynamic: Code sharing, smaller binary, loaded at runtime
                """,
                upvotes: 62
            ),
            // Closures - Advanced
            WebQuestion(
                id: "web-11",
                title: "Closure Retain Cycle with Self",
                question: "Why does this code create a memory leak, and how do you fix it?",
                source: "r/swift",
                sourceType: "reddit",
                difficulty: .hard,
                tags: ["closures", "retain-cycle", "memory-management"],
                solution: "The closure strongly captures self, and if storedClosure is a property of self, they reference each other creating a retain cycle. Use [weak self] or [unowned self] in the capture list.",
                codeSnippet: """
                class ViewController {
                    var storedClosure: (() -> Void)?
                    
                    func setup() {
                        storedClosure = {
                            self.doSomething() // Retain cycle!
                        }
                    }
                    
                    // Fix:
                    storedClosure = { [weak self] in
                        self?.doSomething()
                    }
                }
                """,
                upvotes: 94
            ),
            WebQuestion(
                id: "web-12",
                title: "Escaping vs Non-Escaping Closures",
                question: "When do I need @escaping for a closure parameter?",
                source: "Stack Overflow",
                sourceType: "stackoverflow",
                difficulty: .medium,
                tags: ["closures", "@escaping", "async"],
                solution: "@escaping is required when the closure is called after the function returns, such as when stored as a property, passed to async operations, or used in completion handlers. Non-escaping closures must be called before the function returns.",
                codeSnippet: """
                // Non-escaping (default)
                func process(data: [Int], transform: (Int) -> Int) {
                    // Must call transform before function returns
                    let result = transform(data[0])
                }
                
                // Escaping
                func fetchData(completion: @escaping (Data) -> Void) {
                    URLSession.shared.dataTask { data, _, _ in
                        completion(data!) // Called after function returns
                    }.resume()
                }
                """,
                upvotes: 67
            ),
            // Memory Management
            WebQuestion(
                id: "web-13",
                title: "Weak vs Unowned References",
                question: "When should I use weak vs unowned? What's the difference?",
                source: "Swift Forums",
                sourceType: "swift-forums",
                difficulty: .hard,
                tags: ["weak", "unowned", "memory-management", "arc"],
                solution: "Use weak when the referenced object might be deallocated (becomes optional). Use unowned when you're certain the object will outlive the reference (non-optional, but crashes if accessed after deallocation). Weak is safer but requires optional handling.",
                codeSnippet: """
                // Weak - becomes nil when deallocated
                class Person {
                    weak var apartment: Apartment? // Optional
                }
                
                // Unowned - assumes object exists
                class CreditCard {
                    unowned let customer: Customer // Non-optional
                    // Crashes if customer is deallocated first!
                }
                
                // Rule: If uncertain, use weak
                """,
                upvotes: 78
            ),
            WebQuestion(
                id: "web-14",
                title: "Retain Cycle in Delegate Pattern",
                question: "Why does my delegate pattern create a retain cycle?",
                source: "r/swift",
                sourceType: "reddit",
                difficulty: .medium,
                tags: ["delegate", "retain-cycle", "protocol"],
                solution: "If the delegate property is strong, and the object holding the delegate also holds a reference to the delegating object, you get a cycle. Make the delegate property weak.",
                codeSnippet: """
                protocol MyDelegate: AnyObject { }
                
                class Manager {
                    var delegate: MyDelegate? // Strong - creates cycle!
                }
                
                class Controller: MyDelegate {
                    let manager = Manager()
                    
                    init() {
                        manager.delegate = self // Cycle!
                    }
                }
                
                // Fix: Make delegate weak
                weak var delegate: MyDelegate?
                """,
                upvotes: 52
            ),
            // Dispatch Queues
            WebQuestion(
                id: "web-15",
                title: "Deadlock with DispatchQueue.sync",
                question: "Why does this code freeze the app?",
                source: "Stack Overflow",
                sourceType: "stackoverflow",
                difficulty: .expert,
                tags: ["dispatch-queue", "deadlock", "sync"],
                solution: "Calling sync on the main queue from the main thread causes a deadlock. The main thread is blocked waiting for itself to finish. Never call DispatchQueue.main.sync from the main thread.",
                codeSnippet: """
                // On main thread - DEADLOCK!
                DispatchQueue.main.sync {
                    print("Never executes")
                }
                
                // Fix: Use async
                DispatchQueue.main.async {
                    print("Executes safely")
                }
                
                // Or use Task { @MainActor in ... }
                """,
                upvotes: 125
            ),
            WebQuestion(
                id: "web-16",
                title: "Serial Queue for Thread Safety",
                question: "How do you use a serial queue to make a class thread-safe?",
                source: "Swift Forums",
                sourceType: "swift-forums",
                difficulty: .hard,
                tags: ["dispatch-queue", "thread-safety", "serial"],
                solution: "Use a serial queue to ensure all access to shared state happens on one thread. Wrap all reads and writes in queue.sync or queue.async. This guarantees sequential access.",
                codeSnippet: """
                class ThreadSafeCounter {
                    private let queue = DispatchQueue(label: "counter.queue")
                    private var _count = 0
                    
                    var count: Int {
                        queue.sync { _count }
                    }
                    
                    func increment() {
                        queue.async { [weak self] in
                            self?._count += 1
                        }
                    }
                }
                
                // Modern Swift: Use actor instead
                actor Counter {
                    var count = 0
                    func increment() { count += 1 }
                }
                """,
                upvotes: 88
            ),
            // Threading Concepts
            WebQuestion(
                id: "web-17",
                title: "Race Condition in Counter",
                question: "Why does this counter sometimes return incorrect values?",
                source: "r/swift",
                sourceType: "reddit",
                difficulty: .hard,
                tags: ["threading", "race-condition", "concurrency"],
                solution: "Multiple threads can call increment() simultaneously, and count += 1 is not atomic. Two threads might read the same value, increment it, and write back, losing one increment. Use serial queues, locks, or actors.",
                codeSnippet: """
                class Counter {
                    var count = 0
                    
                    func increment() {
                        count += 1 // Not thread-safe!
                    }
                }
                
                // Thread 1: reads 0, increments to 1
                // Thread 2: reads 0, increments to 1
                // Result: count = 1 (should be 2)
                
                // Fix: Use actor
                actor Counter {
                    var count = 0
                    func increment() { count += 1 }
                }
                """,
                upvotes: 71
            ),
            // Serial/Concurrent + Sync/Async
            WebQuestion(
                id: "web-18",
                title: "Concurrent Queue with Sync",
                question: "If I use sync on a concurrent queue, do tasks still run in parallel?",
                source: "Stack Overflow",
                sourceType: "stackoverflow",
                difficulty: .expert,
                tags: ["dispatch-queue", "concurrent", "sync", "parallelism"],
                solution: "Yes! Even with sync, a concurrent queue can run multiple tasks in parallel if there are multiple sync calls. However, each sync call blocks until its specific task completes. The difference is sync blocks the caller, async doesn't.",
                codeSnippet: """
                let concurrentQueue = DispatchQueue(
                    label: "concurrent",
                    attributes: .concurrent
                )
                
                // These can run in parallel even with sync
                concurrentQueue.sync { task1() }
                concurrentQueue.sync { task2() }
                concurrentQueue.sync { task3() }
                
                // But each sync blocks until that task completes
                """,
                upvotes: 59
            ),
            WebQuestion(
                id: "web-19",
                title: "Dispatch Barrier for Thread-Safe Writes",
                question: "How do you ensure exclusive access for writes in a concurrent queue?",
                source: "Swift Forums",
                sourceType: "swift-forums",
                difficulty: .expert,
                tags: ["dispatch-queue", "barrier", "thread-safety"],
                solution: "Use dispatch barriers (asyncBarrier or syncBarrier) to ensure exclusive access. When a barrier executes, no other tasks in the concurrent queue are running. Perfect for thread-safe writes with concurrent reads.",
                codeSnippet: """
                let queue = DispatchQueue(
                    label: "data",
                    attributes: .concurrent
                )
                
                // Concurrent reads
                func read() -> Data {
                    queue.sync { data }
                }
                
                // Exclusive write
                func write(_ newData: Data) {
                    queue.asyncBarrier {
                        data = newData
                    }
                }
                """,
                upvotes: 43
            ),
            // AVKit
            WebQuestion(
                id: "web-20",
                title: "AVPlayerItem Status Observation",
                question: "How do you properly observe when an AVPlayerItem is ready to play?",
                source: "r/swift",
                sourceType: "reddit",
                difficulty: .hard,
                tags: ["avkit", "avplayer", "kvo"],
                solution: "Observe the status property using KVO or Combine. When status becomes .readyToPlay, the item is ready. Also observe other properties like error, loadedTimeRanges, and isPlaybackLikelyToKeepUp.",
                codeSnippet: """
                let playerItem = AVPlayerItem(url: url)
                
                // KVO approach
                playerItem.addObserver(
                    self,
                    forKeyPath: "status",
                    options: [.new],
                    context: nil
                )
                
                // Combine approach (iOS 13+)
                playerItem.publisher(for: \\.status)
                    .sink { status in
                        if status == .readyToPlay {
                            player.play()
                        }
                    }
                """,
                upvotes: 34
            ),
            WebQuestion(
                id: "web-21",
                title: "Picture-in-Picture Setup",
                question: "How do you enable Picture-in-Picture for video playback?",
                source: "Stack Overflow",
                sourceType: "stackoverflow",
                difficulty: .medium,
                tags: ["avkit", "pip", "avplayerviewcontroller"],
                solution: "Enable PiP capability in project settings, set allowsPictureInPicturePlayback = true on AVPlayerViewController, and implement AVPictureInPictureControllerDelegate methods. Requires proper entitlements.",
                codeSnippet: """
                let playerViewController = AVPlayerViewController()
                playerViewController.allowsPictureInPicturePlayback = true
                
                // Also need:
                // 1. PiP capability enabled in project
                // 2. Background modes: Audio, AirPlay, and Picture in Picture
                // 3. Implement delegate methods
                """,
                upvotes: 28
            ),
            // @Observable vs ObservableObject
            WebQuestion(
                id: "web-22",
                title: "@Observable Property Wrapper Confusion",
                question: "I'm using @Observable but my view isn't updating. What's wrong?",
                source: "r/swift",
                sourceType: "reddit",
                difficulty: .medium,
                tags: ["@Observable", "swiftui", "property-wrappers"],
                solution: "With @Observable, use @State (not @StateObject) to hold the instance. Also, make sure you're not using @Published - @Observable automatically tracks stored properties. Pass instances as plain var parameters to child views.",
                codeSnippet: """
                @Observable
                class ViewModel {
                    var count = 0 // No @Published needed!
                }
                
                struct ContentView: View {
                    @State private var viewModel = ViewModel() // @State, not @StateObject!
                    
                    var body: some View {
                        Text("\\(viewModel.count)")
                    }
                }
                """,
                upvotes: 91
            ),
            WebQuestion(
                id: "web-23",
                title: "Migrating from ObservableObject to @Observable",
                question: "How do I migrate my existing ObservableObject code to @Observable?",
                source: "Swift Forums",
                sourceType: "swift-forums",
                difficulty: .hard,
                tags: ["@Observable", "ObservableObject", "migration"],
                solution: "1. Remove ObservableObject conformance and @Published. 2. Add @Observable macro. 3. Change @StateObject to @State. 4. Change @ObservedObject to plain var. 5. Remove @EnvironmentObject, pass as parameter. 6. Use @Bindable for two-way binding.",
                codeSnippet: """
                // Before
                class ViewModel: ObservableObject {
                    @Published var count = 0
                }
                struct View: SwiftUI.View {
                    @StateObject var vm = ViewModel()
                }
                
                // After
                @Observable
                class ViewModel {
                    var count = 0
                }
                struct View: SwiftUI.View {
                    @State var vm = ViewModel()
                }
                """,
                upvotes: 76
            ),
            // Advanced Concurrency
            WebQuestion(
                id: "web-24",
                title: "TaskGroup Error Handling",
                question: "How do you handle errors in a TaskGroup when one child task fails?",
                source: "Stack Overflow",
                sourceType: "stackoverflow",
                difficulty: .expert,
                tags: ["TaskGroup", "error-handling", "async"],
                solution: "Use withThrowingTaskGroup and handle errors with try-catch. You can either cancel all tasks on first error, or collect errors and continue. Use group.cancelAll() to cancel remaining tasks.",
                codeSnippet: """
                func processItems(_ items: [Item]) async throws -> [Result] {
                    try await withThrowingTaskGroup(of: Result.self) { group in
                        for item in items {
                            group.addTask {
                                try await processItem(item)
                            }
                        }
                        
                        var results: [Result] = []
                        do {
                            for try await result in group {
                                results.append(result)
                            }
                        } catch {
                            group.cancelAll() // Cancel remaining
                            throw error
                        }
                        return results
                    }
                }
                """,
                upvotes: 54
            ),
            WebQuestion(
                id: "web-25",
                title: "AsyncSequence with Cancellation",
                question: "How do you create a cancellable AsyncSequence?",
                source: "Swift Forums",
                sourceType: "swift-forums",
                difficulty: .expert,
                tags: ["AsyncSequence", "cancellation", "async"],
                solution: "Use AsyncStream or implement AsyncSequence protocol. Check for cancellation in the iterator's next() method. Use Task.isCancelled or Task.checkCancellation().",
                codeSnippet: """
                struct NumberSequence: AsyncSequence {
                    typealias Element = Int
                    
                    func makeAsyncIterator() -> AsyncIterator {
                        AsyncIterator()
                    }
                    
                    struct AsyncIterator: AsyncIteratorProtocol {
                        var current = 0
                        
                        mutating func next() async throws -> Int? {
                            try Task.checkCancellation()
                            current += 1
                            return current <= 10 ? current : nil
                        }
                    }
                }
                """,
                upvotes: 38
            ),
            // Swift 6 Migration
            WebQuestion(
                id: "web-26",
                title: "Strict Concurrency Errors",
                question: "Swift 6 is giving me concurrency errors. How do I fix them?",
                source: "r/swift",
                sourceType: "reddit",
                difficulty: .hard,
                tags: ["Swift 6", "concurrency", "migration"],
                solution: "Swift 6 enforces strict concurrency. Common fixes: 1) Make types Sendable, 2) Use actors for mutable state, 3) Mark closures as @Sendable, 4) Use @preconcurrency for legacy APIs, 5) Ensure MainActor isolation for UI code.",
                codeSnippet: """
                // Error: Not Sendable
                class Data { var value: Int }
                
                // Fix 1: Make it Sendable
                struct Data: Sendable { var value: Int }
                
                // Fix 2: Use actor
                actor DataActor {
                    var value: Int
                }
                
                // Fix 3: @preconcurrency for legacy
                import Foundation
                @preconcurrency import SomeLegacyFramework
                """,
                upvotes: 112
            ),
            WebQuestion(
                id: "web-27",
                title: "Actor Isolation Violation",
                question: "Why can't I access actor properties directly from outside?",
                source: "Stack Overflow",
                sourceType: "stackoverflow",
                difficulty: .medium,
                tags: ["actor", "isolation", "Swift 6"],
                solution: "All actor properties and methods are isolated. You must use await to access them from outside the actor, even if the method is synchronous. This is Swift 6's strict concurrency enforcement.",
                codeSnippet: """
                actor Counter {
                    var count = 0
                    func getCount() -> Int { count }
                }
                
                let counter = Counter()
                // let value = counter.count // ERROR: actor-isolated
                let value = await counter.getCount() // OK: await required
                """,
                upvotes: 65
            ),
            // Closures - Capture Lists
            WebQuestion(
                id: "web-28",
                title: "Multiple Capture List Values",
                question: "How do you capture multiple values in a closure capture list?",
                source: "Swift Forums",
                sourceType: "swift-forums",
                difficulty: .medium,
                tags: ["closures", "capture-list"],
                solution: "List multiple captures separated by commas. You can mix weak, unowned, and value captures. Order doesn't matter, but clarity does.",
                codeSnippet: """
                class Manager {
                    func setup() {
                        let local = "value"
                        closure = { [weak self, local, count = self.count] in
                            self?.process(local, count: count)
                        }
                    }
                }
                
                // [weak self] - weak reference
                // local - capture by value
                // count = self.count - capture property by value
                """,
                upvotes: 41
            ),
            // Memory Management - Advanced
            WebQuestion(
                id: "web-29",
                title: "ARC with Protocol Types",
                question: "Do protocol types participate in ARC?",
                source: "r/swift",
                sourceType: "reddit",
                difficulty: .hard,
                tags: ["arc", "protocols", "memory-management"],
                solution: "Protocol types are value types (existential containers), but when they wrap a class instance, ARC applies to the underlying instance. Protocol extensions don't affect ARC - it's the concrete type that matters.",
                codeSnippet: """
                protocol MyProtocol { }
                class MyClass: MyProtocol { }
                
                var instance: MyProtocol = MyClass()
                // ARC applies to the MyClass instance
                // The protocol type itself is just a container
                """,
                upvotes: 33
            ),
            // Dispatch Queue - Advanced Patterns
            WebQuestion(
                id: "web-30",
                title: "QoS Priority Inheritance",
                question: "What happens to QoS when you dispatch work from a high-priority queue to a low-priority queue?",
                source: "Stack Overflow",
                sourceType: "stackoverflow",
                difficulty: .expert,
                tags: ["dispatch-queue", "qos", "priority"],
                solution: "GCD uses QoS priority inheritance. When dispatching from a high-priority queue, the work inherits the higher priority. However, explicitly specifying QoS in the dispatch call overrides inheritance.",
                codeSnippet: """
                let highPriorityQueue = DispatchQueue(
                    label: "high",
                    qos: .userInitiated
                )
                
                highPriorityQueue.async {
                    // This inherits .userInitiated
                    lowPriorityQueue.async {
                        // Still .userInitiated (inherited)
                    }
                    
                    // Explicit QoS overrides
                    lowPriorityQueue.async(qos: .utility) {
                        // Now .utility
                    }
                }
                """,
                upvotes: 27
            )
        ]
    }
}
