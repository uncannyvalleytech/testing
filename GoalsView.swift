// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI
import SwiftData

struct GoalsView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Query to fetch all saved goals, sorted by date.
    @Query(sort: \Goal.startDate, order: .reverse) private var goals: [Goal]
    
    // State variable to control showing the "Add Goal" sheet.
    @State private var showingAddGoalSheet = false

    var body: some View {
        // NEW: Apply the custom background color.
        ZStack {
            Color.primaryBackground.edgesIgnoringSafeArea(.all)
            
            List {
                if goals.isEmpty {
                    // Show a helpful message if no goals have been set.
                    ContentUnavailableView(
                        "No Goals Yet",
                        systemImage: "trophy",
                        description: Text("Tap the '+' button to set a new performance goal.")
                    )
                    // NEW: Ensure the message is visible on the dark background.
                    .foregroundColor(.white)
                } else {
                    ForEach(goals) { goal in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(goal.exercise)
                                .font(.headline)
                                .foregroundColor(.white) // NEW: Set text color for visibility.
                            
                            Text("Target: \(String(format: "%.1f", goal.targetWeight)) lbs x \(goal.targetReps) reps")
                                .font(.subheadline)
                                .foregroundColor(.gray) // NEW: Use a muted color.
                            
                            // A simple progress view. We will make this dynamic later.
                            ProgressView(value: 0.5) // Placeholder progress
                                .tint(.accentBlue) // NEW: Use the vibrant accent color.
                        }
                        .padding(.vertical, 8)
                        // NEW: Use the custom secondary background for each list item.
                        .listRowBackground(Color.secondaryBackground)
                    }
                    .onDelete(perform: deleteGoal) // Enables swipe-to-delete.
                }
            }
            // NEW: Make the list background transparent.
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Goals")
        .toolbar {
            // The "+" button to open the sheet.
            Button(action: { showingAddGoalSheet = true }) {
                Image(systemName: "plus")
            }
            .tint(.accentBlue) // NEW: Apply the vibrant accent color to the button.
        }
        // This modifier presents our "Add Goal" view as a pop-up sheet.
        .sheet(isPresented: $showingAddGoalSheet) {
            SetGoalView()
        }
    }

    // Function to handle deleting a goal.
    private func deleteGoal(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(goals[index])
            }
        }
    }
}

// SECTION 2: PREVIEW
#Preview {
    NavigationStack {
        GoalsView()
            .modelContainer(for: Goal.self, inMemory: true)
    }
}
