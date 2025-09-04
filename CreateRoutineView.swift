//
//  CreateRoutineView.swift
//  atc
//
//  Created by Paul Allen-Howell on 9/1/25.
//

// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI
import SwiftData

struct CreateRoutineView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // State variables for building the new routine.
    @State private var routineName: String = ""
    @State private var days: [WorkoutDayTemplate] = [WorkoutDayTemplate(name: "Day 1")]
    
    // Temporary structs to hold the UI state before saving to SwiftData.
    struct WorkoutDayTemplate: Identifiable {
        let id = UUID()
        var name: String
        var exercises: [ExerciseTemplate] = [ExerciseTemplate()]
    }
    
    // NEW: ExerciseTemplate now has an id to support navigation.
    struct ExerciseTemplate: Identifiable {
        let id = UUID()
        var name: String = ""
        var sets: String = "3"
        var reps: String = "10"
        var muscleGroup: String = "" // NEW: Added a muscle group property.
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Routine Name").foregroundColor(.white)) { // NEW: Set color for visibility.
                    TextField("e.g., My Hypertrophy Plan", text: $routineName)
                        .listRowBackground(Color.secondaryBackground) // NEW: Apply a custom background.
                        .foregroundColor(.white) // NEW: Set color for visibility.
                }

                // Create an editor section for each day.
                ForEach($days) { $day in
                    Section(header: Text(day.name).foregroundColor(.white)) { // NEW: Set color for visibility.
                        TextField("Day Name (e.g., Push Day)", text: $day.name)
                            .listRowBackground(Color.secondaryBackground)
                            .foregroundColor(.white)
                        
                        // Create an editor for each exercise in the day.
                        ForEach($day.exercises) { $exercise in
                            VStack {
                                // CHANGED: This is now a NavigationLink to a new exercise selection view.
                                NavigationLink(destination: ExerciseSelectionView(selectedExercise: $exercise)) {
                                    Text(exercise.name.isEmpty ? "Select Exercise" : exercise.name)
                                        .foregroundColor(exercise.name.isEmpty ? .gray : .white) // NEW: Set colors for visibility.
                                }
                                .listRowSeparator(.hidden)
                                
                                HStack {
                                    TextField("Sets", text: $exercise.sets).keyboardType(.numberPad)
                                        .textFieldStyle(.roundedBorder)
                                        .background(Color.secondaryBackground) // NEW: Apply a custom background.
                                        .foregroundColor(.white)
                                    TextField("Reps", text: $exercise.reps).keyboardType(.numberPad)
                                        .textFieldStyle(.roundedBorder)
                                        .background(Color.secondaryBackground)
                                        .foregroundColor(.white)
                                }
                            }
                            .listRowBackground(Color.secondaryBackground) // NEW: Apply a custom background to each exercise row.
                        }
                        .onDelete { offsets in
                            day.exercises.remove(atOffsets: offsets)
                        }
                        
                        Button("Add Exercise") {
                            day.exercises.append(ExerciseTemplate())
                        }
                        .foregroundColor(.accentBlue) // NEW: Apply accent color.
                        .listRowBackground(Color.secondaryBackground)
                    }
                }
                
                // Button to add a new day to the routine.
                Section {
                    Button("Add Day") {
                        days.append(WorkoutDayTemplate(name: "Day \(days.count + 1)"))
                    }
                    .foregroundColor(.accentBlue)
                    .listRowBackground(Color.secondaryBackground)
                }
            }
            // NEW: Apply custom background colors to the form and its content.
            .background(Color.primaryBackground)
            .scrollContentBackground(.hidden)
            .navigationTitle("New Routine")
            .navigationBarTitleDisplayMode(.inline)
            // NEW: Set navigation bar colors.
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.secondaryBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.accentBlue) // NEW: Apply accent color.
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: saveRoutine)
                        .disabled(routineName.isEmpty)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        // NEW: Make the save button a vibrant gradient.
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.accentBlue, .neonGreen]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(8)
                }
            }
        }
    }

    // SECTION 2: SAVE FUNCTION
    private func saveRoutine() {
        // 1. Create the main Routine object.
        let newRoutine = Routine(
            name: routineName,
            primaryFocus: "Custom",
            daysPerWeek: days.count,
            isCustom: true
        )
        
        // 2. Create and link all the child WorkoutDay and Exercise objects.
        var workoutDays: [WorkoutDay] = []
        for (index, dayTemplate) in days.enumerated() {
            let workoutDay = WorkoutDay(name: dayTemplate.name, dayNumber: index + 1)
            var exercises: [Exercise] = []
            
            for exerciseTemplate in dayTemplate.exercises where !exerciseTemplate.name.isEmpty {
                let exercise = Exercise(
                    name: exerciseTemplate.name,
                    sets: Int(exerciseTemplate.sets) ?? 3,
                    targetReps: exerciseTemplate.reps,
                    muscleGroup: exerciseTemplate.muscleGroup // CHANGED: Now uses the selected muscle group.
                )
                exercises.append(exercise)
            }
            workoutDay.exercises = exercises
            workoutDay.routine = newRoutine
            workoutDays.append(workoutDay)
        }
        
        newRoutine.workoutDays = workoutDays
        
        // 3. Insert the fully constructed routine into the database.
        modelContext.insert(newRoutine)
        
        // CHANGED: Added save to persist the new routine.
        try? modelContext.save()
        
        dismiss()
    }
}

// SECTION 3: PREVIEW
#Preview {
    CreateRoutineView()
}
