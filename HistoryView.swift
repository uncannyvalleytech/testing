import SwiftUI
import SwiftData

struct HistoryView: View {
    // This query fetches all WorkoutHistory objects and sorts them by date, with the newest first.
    @Query(sort: \WorkoutHistory.date, order: .reverse) private var workoutHistory: [WorkoutHistory]

    var body: some View {
        // A List is perfect for displaying a scrollable history.
        List(workoutHistory) { session in
            VStack(alignment: .leading, spacing: 8) {
                // Main details of the workout session.
                HStack {
                    Text(session.name)
                        .font(.headline)
                    Spacer()
                    Text(session.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // A summary of the workout stats.
                Text("Volume: \(Int(session.totalVolume)) lbs  ·  Duration: \(formatDuration(seconds: session.durationInSeconds))")
                    .font(.caption)
                    .foregroundColor(.secondary)

                // Display the details of each exercise within the session.
                if let exercises = session.exercises {
                    ForEach(exercises) { exercise in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exercise.name)
                                .fontWeight(.semibold)
                            
                            // Display each set for the exercise.
                            ForEach(exercise.sets ?? []) { set in
                                Text("  · \(set.reps) reps at \(String(format: "%.1f", set.weight)) lbs")
                                    .font(.footnote)
                            }
                        }
                        .padding(.top, 5)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("History") // Sets the title at the top of the screen.
    }
    
    // Helper function to format duration, also used in WorkoutSummaryView.
    func formatDuration(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return "\(minutes)m \(remainingSeconds)s"
    }
}

#Preview {
    // For the preview, we need a NavigationStack to see the title correctly.
    NavigationStack {
        HistoryView()
            .modelContainer(for: WorkoutHistory.self, inMemory: true)
    }
}
