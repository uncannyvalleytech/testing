// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI

struct ExerciseSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    // We bind to the exercise template so we can update it when a selection is made.
    @Binding var selectedExercise: CreateRoutineView.ExerciseTemplate

    // State variables to control the view's flow.
    @State private var allMuscleGroups: [String] = []
    @State private var selectedMuscleGroup: String? = nil
    @State private var filteredExercises: [WorkoutEngine.ExerciseDefinition] = []

    // Access the workout engine to get data.
    private let engine = WorkoutEngine(userProfile: UserProfile())

    var body: some View {
        // We use a Group to switch between the muscle group list and the exercise list.
        Group {
            if selectedMuscleGroup == nil {
                muscleGroupListView
            } else {
                exerciseListView
            }
        }
        .navigationTitle(selectedMuscleGroup?.capitalized ?? "Select Muscle Group")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
        .onAppear {
            // Load all muscle groups when the view appears.
            self.allMuscleGroups = engine.getAllMuscleGroups()
        }
    }
    
    // MARK: - Muscle Group Selection View
    private var muscleGroupListView: some View {
        List(allMuscleGroups, id: \.self) { group in
            Button(action: {
                selectedMuscleGroup = group
                self.filteredExercises = engine.exerciseDatabase[group] ?? []
            }) {
                HStack {
                    Text(group.capitalized)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    // MARK: - Exercise Selection View
    private var exerciseListView: some View {
        List(filteredExercises, id: \.name) { exercise in
            Button(action: {
                // When an exercise is selected, update the binding.
                selectedExercise.name = exercise.name
                selectedExercise.muscleGroup = selectedMuscleGroup ?? ""
                dismiss() // Then dismiss the view.
            }) {
                VStack(alignment: .leading) {
                    Text(exercise.name).font(.headline)
                    Text(exercise.equipment.joined(separator: ", ").capitalized)
                        .font(.subheadline).foregroundColor(.secondary)
                }
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    NavigationStack {
        // Create a dummy binding for the preview.
        let binding = Binding<CreateRoutineView.ExerciseTemplate>(
            get: { .init() },
            set: { _ in }
        )
        ExerciseSelectionView(selectedExercise: binding)
    }
}
