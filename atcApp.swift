import SwiftUI
import SwiftData

@main
struct atcApp: App {
    var sharedModelContainer: ModelContainer = {
        // Add the new Goal model to the schema.
        let schema = Schema([
            UserProfile.self,
            Routine.self,
            WorkoutDay.self,
            Exercise.self,
            WorkoutHistory.self,
            CompletedExercise.self,
            CompletedSet.self,
            Goal.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
