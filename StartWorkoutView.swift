// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI
import SwiftData

struct StartWorkoutView: View {
    @Query private var profiles: [UserProfile]
    
    @State private var selectedMuscleGroups: Set<String> = []
    
    // State to control showing the readiness modal.
    @State private var showingReadinessModal = false
    
    // State to hold the workout, which will trigger navigation *after* the modal is handled.
    @State private var workoutToStart: WorkoutDay? = nil

    private let allMuscleGroups = ["chest", "back", "quads", "hamstrings", "glutes", "shoulders", "biceps", "triceps"]

    var body: some View {
        ZStack {
            // NEW: Use the custom background color.
            Color.primaryBackground.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("What are you training today?")
                    .font(.largeTitle).fontWeight(.bold)
                    .foregroundColor(.white) // NEW: Set text color for visibility.
                
                Text("Select up to three muscle groups to generate a workout.")
                    .foregroundColor(.gray).padding(.bottom) // NEW: Use a muted color.

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(allMuscleGroups, id: \.self) { group in
                            Button(action: { toggleSelection(for: group) }) {
                                Text(group.capitalized)
                                    .fontWeight(.bold).frame(maxWidth: .infinity).padding()
                                    // NEW: Use the custom secondary background and accent blue.
                                    .background(selectedMuscleGroups.contains(group) ? Color.accentBlue : Color.secondaryBackground)
                                    .foregroundColor(selectedMuscleGroups.contains(group) ? .white : .primary)
                                    .cornerRadius(12)
                            }
                        }
                    }
                }

                Spacer()

                // This button now shows the readiness modal instead of navigating directly.
                Button("Generate Workout") {
                    showingReadinessModal = true
                }
                .fontWeight(.semibold).frame(maxWidth: .infinity).padding()
                // NEW: Use custom colors for the button.
                .background(selectedMuscleGroups.isEmpty ? Color.secondaryBackground : Color.accentBlue)
                .foregroundColor(.white).cornerRadius(10)
                .disabled(selectedMuscleGroups.isEmpty)
            }
            .padding()
            .navigationTitle("Start Dynamic Workout")
            .navigationBarTitleDisplayMode(.inline)
            // NEW: Set the navigation bar title color.
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.secondaryBackground, for: .navigationBar)
        }
        // This sheet modifier presents the readiness modal.
        .sheet(isPresented: $showingReadinessModal) {
            ReadinessModalView { readinessData in
                // This code runs when the user submits their readiness.
                generateAndStartWorkout(readiness: readinessData)
            }
        }
        // This navigationDestination is now triggered when `workoutToStart` gets a value.
        .navigationDestination(item: $workoutToStart) { workout in
            WorkoutSessionView(workoutDay: workout)
        }
    }

    private func toggleSelection(for group: String) {
        if selectedMuscleGroups.contains(group) {
            selectedMuscleGroups.remove(group)
        } else if selectedMuscleGroups.count < 3 {
            selectedMuscleGroups.insert(group)
        }
    }
    
    private func generateAndStartWorkout(readiness: ReadinessModalView.ReadinessData) {
        guard let userProfile = profiles.first else { return }
        let engine = WorkoutEngine(userProfile: userProfile)
        
        // Generate the base workout
        let generatedWorkout = engine.generateDailyWorkout(for: Array(selectedMuscleGroups))
        
        // Calculate recovery score
        let recoveryScore = engine.calculateRecoveryScore(readinessData: readiness)
        
        // Adjust the workout based on the recovery score
        let adjustedWorkout = engine.adjustWorkout(workout: generatedWorkout, readinessScore: recoveryScore)
        
        // Setting this state variable triggers the navigation to the workout session.
        self.workoutToStart = adjustedWorkout
    }
}

// SECTION 2: PREVIEW
#Preview {
    NavigationStack {
        let container = try! ModelContainer(for: UserProfile.self, configurations: .init(isStoredInMemoryOnly: true))
        container.mainContext.insert(UserProfile())
        return StartWorkoutView()
            .modelContainer(container)
    }
}
