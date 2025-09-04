// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI
import SwiftData

struct SetGoalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // State variables to hold the form input.
    @State private var tempExerciseSelection = CreateRoutineView.ExerciseTemplate()
    @State private var targetWeight: String = ""
    @State private var targetReps: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                // NEW: Use the custom primary background color.
                Color.primaryBackground.edgesIgnoringSafeArea(.all)
                
                Form {
                    Section(header: Text("Goal Details").foregroundColor(.white)) { // NEW: Set color for visibility.
                        // CHANGED: This is now a NavigationLink to the exercise selection view.
                        NavigationLink(destination: ExerciseSelectionView(selectedExercise: $tempExerciseSelection)) {
                            Text(tempExerciseSelection.name.isEmpty ? "Select Exercise" : tempExerciseSelection.name)
                                .foregroundColor(tempExerciseSelection.name.isEmpty ? .gray : .white)
                        }
                        .listRowBackground(Color.secondaryBackground)
                        
                        TextField("Target Weight (lbs)", text: $targetWeight)
                            .keyboardType(.decimalPad)
                            .listRowBackground(Color.secondaryBackground)
                            .foregroundColor(.white)
                        
                        TextField("Target Reps", text: $targetReps)
                            .keyboardType(.numberPad)
                            .listRowBackground(Color.secondaryBackground)
                            .foregroundColor(.white)
                    }
                }
                // NEW: Make the list background transparent and apply a custom background to rows.
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            // NEW: Set navigation bar colors.
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.secondaryBackground, for: .navigationBar)
            .toolbar {
                // Add "Cancel" and "Save" buttons to the navigation bar.
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.accentBlue) // NEW: Apply accent color.
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: saveGoal)
                        .disabled(tempExerciseSelection.name.isEmpty || targetWeight.isEmpty || targetReps.isEmpty)
                        .foregroundColor(.accentBlue) // NEW: Apply accent color.
                }
            }
        }
    }
    
    private func saveGoal() {
        let newGoal = Goal(
            exercise: tempExerciseSelection.name,
            targetWeight: Double(targetWeight) ?? 0,
            targetReps: Int(targetReps) ?? 0
        )
        modelContext.insert(newGoal)
        dismiss() // Close the sheet after saving.
    }
}

// SECTION 2: PREVIEW
#Preview {
    SetGoalView()
}
