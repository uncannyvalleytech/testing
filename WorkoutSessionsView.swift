// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI
import SwiftData

struct WorkoutSessionView: View {
    @Environment(\.dismiss) private var dismiss
    let workoutDay: WorkoutDay
    
    @State private var completedWorkout: WorkoutHistory? = nil
    @State private var exerciseToSubstitute: Exercise? = nil
    @State private var newlyCompletedGoal: Goal? = nil

    var body: some View {
        ZStack {
            Color.primaryBackground.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(workoutDay.name)
                    .font(.largeTitle).fontWeight(.bold).padding(.bottom, 20)
                    .foregroundColor(.white)
                
                ExerciseTabView(workoutDay: workoutDay, completedWorkout: $completedWorkout, exerciseToSubstitute: $exerciseToSubstitute, newlyCompletedGoal: $newlyCompletedGoal)
            }
        }
        .navigationTitle("Workout")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.secondaryBackground, for: .navigationBar)
        .navigationDestination(item: $completedWorkout) { workoutHistory in
            WorkoutSummaryView(workoutHistory: workoutHistory, newlyCompletedGoal: newlyCompletedGoal, onContinue: {
                 if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                 }
                 dismiss()
            })
        }
        .sheet(item: $exerciseToSubstitute) { exercise in
            ExerciseSubstitutionView(originalExercise: exercise, onSelect: { newExerciseName in
                print("Selected new exercise: \(newExerciseName)")
            })
        }
    }
}

// SECTION 2: EXERCISETABVIEW STRUCT
struct ExerciseTabView: View {
    let workoutDay: WorkoutDay
    @Binding var completedWorkout: WorkoutHistory?
    @Binding var exerciseToSubstitute: Exercise?
    @Binding var newlyCompletedGoal: Goal?
    
    @State private var activeExerciseIndex: Int = 0

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<(workoutDay.exercises?.count ?? 0), id: \.self) { index in
                        Button(action: { activeExerciseIndex = index }) {
                            Text(workoutDay.exercises?[index].name ?? "Unknown")
                                .padding()
                                .background(activeExerciseIndex == index ? Color.accentBlue : Color.secondaryBackground)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            if let exercises = workoutDay.exercises, !exercises.isEmpty {
                ExerciseLoggingView(
                    exercise: exercises[activeExerciseIndex],
                    completedWorkout: $completedWorkout,
                    workoutName: workoutDay.name,
                    newlyCompletedGoal: $newlyCompletedGoal,
                    onSubstitute: {
                        self.exerciseToSubstitute = exercises[activeExerciseIndex]
                    }
                )
            } else {
                Text("No exercises in this workout.")
                Spacer()
            }
        }
    }
}

// SECTION 3: EXERCISELOGGINGVIEW STRUCT
struct ExerciseLoggingView: View {
    @Environment(\.modelContext) private var modelContext
    let exercise: Exercise
    @Binding var completedWorkout: WorkoutHistory?
    let workoutName: String
    @Binding var newlyCompletedGoal: Goal?
    let onSubstitute: () -> Void

    @Query(filter: #Predicate<Goal> { !$0.isCompleted }) private var activeGoals: [Goal]
    
    struct SetEntry: Identifiable {
        let id = UUID()
        var weight: String = ""
        var reps: String = ""
        var isCompleted: Bool = false
    }
    
    @State private var setEntries: [SetEntry]
    @State private var startTime = Date()

    init(exercise: Exercise, completedWorkout: Binding<WorkoutHistory?>, workoutName: String, newlyCompletedGoal: Binding<Goal?>, onSubstitute: @escaping () -> Void) {
        self.exercise = exercise
        self._completedWorkout = completedWorkout
        self.workoutName = workoutName
        self._newlyCompletedGoal = newlyCompletedGoal
        self.onSubstitute = onSubstitute
        _setEntries = State(initialValue: Array(repeating: SetEntry(), count: exercise.sets))
    }
    
    var body: some View {
        List {
            HStack {
                Text(exercise.name).font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button(action: onSubstitute) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(.accentBlue)
                }
            }
            
            HStack {
                Text("Set").frame(width: 50)
                Text("Weight (lbs)").frame(maxWidth: .infinity)
                Text("Reps").frame(maxWidth: .infinity)
                Text("Done").frame(width: 50)
            }
            .font(.caption).foregroundColor(.gray)
            
            ForEach(0..<setEntries.count, id: \.self) { index in
                HStack {
                    Text("\(index + 1)").frame(width: 50)
                        .foregroundColor(.white)
                    TextField("0", text: $setEntries[index].weight).keyboardType(.decimalPad)
                        .background(Color.secondaryBackground)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    TextField(exercise.targetReps, text: $setEntries[index].reps).keyboardType(.numberPad)
                        .background(Color.secondaryBackground)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    Button(action: { setEntries[index].isCompleted.toggle() }) {
                        Image(systemName: setEntries[index].isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(setEntries[index].isCompleted ? .neonGreen : .gray)
                    }
                    .frame(width: 50)
                }
            }
            
            Button("Complete Workout", action: saveWorkout)
                .padding().frame(maxWidth: .infinity)
                .background(Color.neonGreen)
                .foregroundColor(.white)
                .cornerRadius(10).listRowInsets(EdgeInsets())
        }
        .scrollContentBackground(.hidden)
        .background(Color.primaryBackground)
    }
    
    private func checkForGoalCompletion(in session: WorkoutHistory) {
        guard let completedExercises = session.exercises else { return }

        for exercise in completedExercises {
            let matchingGoals = activeGoals.filter { $0.exercise == exercise.name }
            
            guard !matchingGoals.isEmpty, let completedSets = exercise.sets else { continue }
            
            for goal in matchingGoals {
                for set in completedSets {
                    if set.weight >= goal.targetWeight && set.reps >= goal.targetReps {
                        goal.isCompleted = true
                        newlyCompletedGoal = goal
                        break
                    }
                }
            }
        }
    }
    
    func saveWorkout() {
        let duration = Int(Date().timeIntervalSince(startTime))
        var totalVolume: Double = 0
        let session = WorkoutHistory(date: .now, name: workoutName, durationInSeconds: duration, totalVolume: 0)
        let completedExercise = CompletedExercise(name: exercise.name, muscleGroup: exercise.muscleGroup)
        var completedSets: [CompletedSet] = []
        for entry in setEntries where entry.isCompleted {
            let weight = Double(entry.weight) ?? 0
            let reps = Int(entry.reps) ?? 0
            totalVolume += weight * Double(reps)
            let completedSet = CompletedSet(weight: weight, reps: reps, rir: 0)
            completedSets.append(completedSet)
        }
        
        completedExercise.sets = completedSets
        completedExercise.session = session
        session.exercises = [completedExercise]
        session.totalVolume = totalVolume
        
        checkForGoalCompletion(in: session)
        
        modelContext.insert(session)
        
        self.completedWorkout = session
    }
}

// SECTION 4: EXERCISESUBSTITUTIONVIEW STRUCT
struct ExerciseSubstitutionView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var profiles: [UserProfile]
    
    let originalExercise: Exercise
    let onSelect: (String) -> Void
    
    @State private var suggestedExercises: [WorkoutEngine.ExerciseDefinition] = []

    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryBackground.edgesIgnoringSafeArea(.all)
                
                List(suggestedExercises, id: \.name) { exerciseDef in
                    Button(action: {
                        onSelect(exerciseDef.name)
                        dismiss()
                    }) {
                        VStack(alignment: .leading) {
                            Text(exerciseDef.name).font(.headline).foregroundColor(.white)
                            Text(exerciseDef.equipment.joined(separator: ", ").capitalized)
                                .font(.subheadline).foregroundColor(.gray)
                        }
                    }
                    .listRowBackground(Color.secondaryBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Substitute Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.secondaryBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.accentBlue)
                }
            }
            .onAppear(perform: loadSubstitutions)
        }
    }
    
    private func loadSubstitutions() {
        guard let profile = profiles.first else { return }
        let engine = WorkoutEngine(userProfile: profile)
        self.suggestedExercises = engine.getExerciseSubstitutions(for: originalExercise)
    }
}
