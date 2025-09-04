// SECTION 1: IMPORTS AND MAIN CLASS
import Foundation

class WorkoutEngine {
    let userProfile: UserProfile

    init(userProfile: UserProfile) {
        self.userProfile = userProfile
    }

    // SECTION 2: EXERCISE DATABASE
    let exerciseDatabase: [String: [ExerciseDefinition]] = [
        "chest": [
            .init(name: "Barbell Bench Press", type: .compound, equipment: ["barbell", "bench", "rack"], movementPattern: "horizontal_press", recoveryCost: "medium"),
            .init(name: "Dumbbell Bench Press", type: .compound, equipment: ["dumbbell", "bench"], movementPattern: "horizontal_press", recoveryCost: "medium"),
            .init(name: "Incline Dumbbell Press", type: .compound, equipment: ["dumbbell", "adjustable_bench"], movementPattern: "incline_press", recoveryCost: "medium"),
            .init(name: "Machine Chest Press", type: .compound, equipment: ["machine"], movementPattern: "horizontal_press", recoveryCost: "low"),
            .init(name: "Cable Crossover", type: .isolation, equipment: ["cable"], movementPattern: "fly", recoveryCost: "low"),
            .init(name: "Push-ups", type: .compound, equipment: ["bodyweight"], movementPattern: "horizontal_press", recoveryCost: "low"),
            .init(name: "Decline Dumbbell Press", type: .compound, equipment: ["dumbbell", "adjustable_bench"], movementPattern: "decline_press", recoveryCost: "medium"),
            .init(name: "Dumbbell Flyes", type: .isolation, equipment: ["dumbbell", "bench"], movementPattern: "fly", recoveryCost: "low"),
            .init(name: "Machine Fly", type: .isolation, equipment: ["machine"], movementPattern: "fly", recoveryCost: "low")
        ],
        "back": [
            .init(name: "Deadlift", type: .compound, equipment: ["barbell", "rack"], movementPattern: "hinge", recoveryCost: "high"),
            .init(name: "Pull-ups", type: .compound, equipment: ["pullup_bar"], movementPattern: "vertical_pull", recoveryCost: "medium"),
            .init(name: "Barbell Row", type: .compound, equipment: ["barbell"], movementPattern: "horizontal_pull", recoveryCost: "medium"),
            .init(name: "Lat Pulldown", type: .compound, equipment: ["cable", "machine"], movementPattern: "vertical_pull", recoveryCost: "low"),
            .init(name: "Seated Cable Row", type: .compound, equipment: ["cable", "machine"], movementPattern: "horizontal_pull", recoveryCost: "low"),
            .init(name: "T-Bar Row", type: .compound, equipment: ["barbell", "plate"], movementPattern: "horizontal_pull", recoveryCost: "medium"),
            .init(name: "Hyperextensions", type: .isolation, equipment: ["bodyweight"], movementPattern: "hinge", recoveryCost: "low"),
            .init(name: "Face Pulls", type: .isolation, equipment: ["cable"], movementPattern: "rear_delt_pull", recoveryCost: "low")
        ],
        "quads": [
            .init(name: "Barbell Squat", type: .compound, equipment: ["barbell", "rack"], movementPattern: "squat", recoveryCost: "high"),
            .init(name: "Leg Press", type: .compound, equipment: ["machine"], movementPattern: "squat", recoveryCost: "medium"),
            .init(name: "Goblet Squat", type: .compound, equipment: ["dumbbell"], movementPattern: "squat", recoveryCost: "low"),
            .init(name: "Dumbbell Lunges", type: .compound, equipment: ["dumbbell"], movementPattern: "lunge", recoveryCost: "medium"),
            .init(name: "Leg Extension", type: .isolation, equipment: ["machine"], movementPattern: "knee_extension", recoveryCost: "low"),
            .init(name: "Hack Squat", type: .compound, equipment: ["machine"], movementPattern: "squat", recoveryCost: "high"),
            .init(name: "Bulgarian Split Squat", type: .compound, equipment: ["dumbbell", "bench"], movementPattern: "lunge", recoveryCost: "high")
        ],
        "hamstrings": [
            .init(name: "Romanian Deadlift", type: .compound, equipment: ["barbell", "dumbbell"], movementPattern: "hinge", recoveryCost: "medium"),
            .init(name: "Lying Leg Curl", type: .isolation, equipment: ["machine"], movementPattern: "leg_curl", recoveryCost: "low"),
            .init(name: "Glute Bridge", type: .isolation, equipment: ["bodyweight"], movementPattern: "hinge", recoveryCost: "low"),
            .init(name: "Good Mornings", type: .compound, equipment: ["barbell"], movementPattern: "hinge", recoveryCost: "medium")
        ],
        "glutes": [
            .init(name: "Barbell Hip Thrust", type: .compound, equipment: ["barbell", "bench", "plate"], movementPattern: "hinge", recoveryCost: "medium"),
            .init(name: "Glute Cable Kickback", type: .isolation, equipment: ["cable"], movementPattern: "hip_extension", recoveryCost: "low"),
            .init(name: "Abduction Machine", type: .isolation, equipment: ["machine"], movementPattern: "hip_abduction", recoveryCost: "low"),
            .init(name: "Cable Pull-Through", type: .compound, equipment: ["cable"], movementPattern: "hinge", recoveryCost: "low"),
            .init(name: "Bulgarian Split Squat", type: .compound, equipment: ["dumbbell", "bench"], movementPattern: "lunge", recoveryCost: "high")
        ],
        "shoulders": [
            .init(name: "Overhead Press", type: .compound, equipment: ["barbell", "rack"], movementPattern: "vertical_press", recoveryCost: "medium"),
            .init(name: "Seated Dumbbell Shoulder Press", type: .compound, equipment: ["dumbbell", "adjustable_bench"], movementPattern: "vertical_press", recoveryCost: "medium"),
            .init(name: "Lateral Raise", type: .isolation, equipment: ["dumbbell"], movementPattern: "lateral_raise", recoveryCost: "low"),
            .init(name: "Face Pulls", type: .isolation, equipment: ["cable"], movementPattern: "rear_delt_pull", recoveryCost: "low"),
            .init(name: "Machine Shoulder Press", type: .compound, equipment: ["machine"], movementPattern: "vertical_press", recoveryCost: "low")
        ],
        "biceps": [
            .init(name: "Barbell Curl", type: .isolation, equipment: ["barbell"], movementPattern: "bicep_curl", recoveryCost: "low"),
            .init(name: "Dumbbell Bicep Curls", type: .isolation, equipment: ["dumbbell"], movementPattern: "bicep_curl", recoveryCost: "low"),
            .init(name: "Preacher Curls", type: .isolation, equipment: ["barbell", "machine"], movementPattern: "bicep_curl", recoveryCost: "low"),
            .init(name: "Hammer Curl", type: .isolation, equipment: ["dumbbell"], movementPattern: "bicep_curl", recoveryCost: "low")
        ],
        "triceps": [
            .init(name: "Triceps Rope Pushdown", type: .isolation, equipment: ["cable"], movementPattern: "tricep_extension", recoveryCost: "low"),
            .init(name: "Overhead Cable Tricep Extension", type: .isolation, equipment: ["cable"], movementPattern: "tricep_extension", recoveryCost: "low"),
            .init(name: "Close Grip Bench Press", type: .compound, equipment: ["barbell", "bench"], movementPattern: "tricep_press", recoveryCost: "medium"),
            .init(name: "Skullcrushers", type: .isolation, equipment: ["barbell", "dumbbell"], movementPattern: "tricep_extension", recoveryCost: "low")
        ],
        "calves": [
            .init(name: "Standing Calf Raise", type: .isolation, equipment: ["machine"], movementPattern: "calf_raise", recoveryCost: "low"),
            .init(name: "Seated Calf Raise", type: .isolation, equipment: ["machine"], movementPattern: "calf_raise", recoveryCost: "low")
        ],
        "abs": [
            .init(name: "Plank", type: .isolation, equipment: ["bodyweight"], movementPattern: "core_stability", recoveryCost: "low"),
            .init(name: "Lying Leg Raises", type: .isolation, equipment: ["bodyweight"], movementPattern: "core_flexion", recoveryCost: "low"),
            .init(name: "Cable Crunch", type: .isolation, equipment: ["cable"], movementPattern: "core_flexion", recoveryCost: "low"),
            .init(name: "Hanging Leg Raise", type: .isolation, equipment: ["pullup_bar"], movementPattern: "core_flexion", recoveryCost: "low")
        ]
    ]

    struct ExerciseDefinition {
        let name: String
        let type: ExerciseType
        let equipment: [String]
        let movementPattern: String
        let recoveryCost: String
        enum ExerciseType { case compound, isolation }
    }
    
    // SECTION 3: EXERCISE SUBSTITUTION LOGIC
    func getExerciseSubstitutions(for originalExercise: Exercise) -> [ExerciseDefinition] {
        guard let originalDef = findExerciseDefinition(forName: originalExercise.name) else { return [] }
        
        let allExercises = exerciseDatabase.values.flatMap { $0 }
        
        let potentialSubs = allExercises.filter { subDef in
            guard subDef.name != originalDef.name else { return false }
            return subDef.equipment.allSatisfy { userProfile.availableEquipment.contains($0) }
        }
        
        let rankedSubs = potentialSubs.map { subDef -> (definition: ExerciseDefinition, score: Int) in
            var score = 0
            if subDef.movementPattern == originalDef.movementPattern { score += 10 }
            if subDef.type == originalDef.type { score += 5 }
            return (definition: subDef, score: score)
        }
        .sorted { $0.score > $1.score }
        .prefix(5)
        
        return rankedSubs.map { $0.definition }
    }

    func findExerciseDefinition(forName name: String) -> ExerciseDefinition? {
        return exerciseDatabase.values.flatMap { $0 }.first { $0.name == name }
    }

    // SECTION 4: WORKOUT GENERATION AND AUTOREGULATION
    func generateDailyWorkout(for muscleGroups: [String]) -> WorkoutDay {
        var exercises: [Exercise] = []
        for group in muscleGroups {
            let compoundsToSelect = (group == "biceps" || group == "triceps") ? 1 : 2
            let isolationsToSelect = 1
            let compoundExercises = selectExercises(for: group, type: .compound, count: compoundsToSelect)
            let isolationExercises = selectExercises(for: group, type: .isolation, count: isolationsToSelect)
            exercises.append(contentsOf: compoundExercises)
            exercises.append(contentsOf: isolationExercises)
        }
        let workoutName = muscleGroups.map { $0.capitalized }.joined(separator: " & ")
        return WorkoutDay(name: "Dynamic \(workoutName) Day", dayNumber: 1, exercises: exercises)
    }

    private func selectExercises(for muscleGroup: String, type: ExerciseDefinition.ExerciseType, count: Int) -> [Exercise] {
        guard let availableExercises = exerciseDatabase[muscleGroup] else { return [] }
        
        let filteredByEquipment = availableExercises.filter { exerciseDef in
            exerciseDef.equipment.allSatisfy { userProfile.availableEquipment.contains($0) }
        }
        
        let context: (weakMuscles: [String], recentExercises: [String], gender: String) = (weakMuscles: [], recentExercises: [], gender: userProfile.sex)
        
        let scoredExercises = filteredByEquipment.filter { $0.type == type }.map { ex in
            (exercise: ex, score: calculateEPS(exercise: ex, context: context))
        }.sorted { $0.score > $1.score }
        
        let selected = scoredExercises.prefix(count).map { $0.exercise }
        
        return selected.map { definition in
            let sets = (definition.type == .compound) ? 3 : 4
            let reps = (definition.type == .compound) ? "6-10" : "10-15"
            return Exercise(name: definition.name, sets: sets, targetReps: reps, muscleGroup: muscleGroup)
        }
    }
    
    func getAllMuscleGroups() -> [String] {
        return Array(exerciseDatabase.keys).sorted()
    }

    // MARK: - Ported Algorithms from JavaScript
    
    func calculateTAF() -> Double {
        let trainingMonths = Double(userProfile.trainingMonths)
        let taf = 1.0 + (trainingMonths / 12.0) * 0.1
        return min(taf, 3.0)
    }
    
    func calculateRCS() -> Double {
        let baseRecovery = 1.0
        let sexModifier = userProfile.sex == "female" ? 1.15 : 1.0
        let ageModifier = max(0.7, 1.2 - (Double(userProfile.age) - 18.0) * 0.005)
        let sleepModifier = min(1.2, userProfile.sleepHours / 8.0)
        let stressModifier = (10.0 - Double(userProfile.stressLevel)) / 10.0
        return baseRecovery * sexModifier * ageModifier * sleepModifier * stressModifier
    }

    func calculateRecoveryScore(readinessData: ReadinessModalView.ReadinessData) -> Double {
        let sorenessInverse = 11.0 - readinessData.muscleSoreness
        return (readinessData.sleepQuality + readinessData.energyLevel + readinessData.motivation + sorenessInverse) / 4.0
    }
    
    func adjustWorkout(workout: WorkoutDay, readinessScore: Double) -> WorkoutDay {
        let adjustedWorkout = workout
        var adjustmentNote = "Workout is as planned."
        
        if readinessScore < 6 {
            adjustmentNote = "Readiness is low. Volume reduced by 20% and intensity reduced."
            adjustedWorkout.exercises?.forEach { ex in
                if ex.sets > 3 {
                    ex.sets -= 1
                }
                if let reps = Int(ex.targetReps.components(separatedBy: "-").first ?? "8") {
                    ex.targetReps = "\(max(5, reps - 2))"
                }
            }
        } else if readinessScore > 8 {
            adjustmentNote = "Feeling great! Increasing intensity slightly."
            adjustedWorkout.exercises?.forEach { ex in
                if let reps = Int(ex.targetReps.components(separatedBy: "-").first ?? "8") {
                    ex.targetReps = "\(reps + 1)"
                }
            }
        }
        
        // You could add the adjustmentNote to the WorkoutDay if you modify its model
        return adjustedWorkout
    }
    
    func calculateEPS(exercise: ExerciseDefinition, context: (weakMuscles: [String], recentExercises: [String], gender: String)) -> Double {
        let compoundBonus = exercise.type == .compound ? 3.0 : 1.0
        let isWeakMuscle = context.weakMuscles.contains(where: { $0 == exercise.name })
        let weaknessMultiplier = isWeakMuscle ? 1.5 : 1.0
        
        var noveltyFactor = 0.0
        if !context.recentExercises.contains(exercise.name) {
            noveltyFactor = 2.0
        } else if (context.recentExercises.firstIndex(of: exercise.name) ?? 0) > 4 {
            noveltyFactor = 1.0
        }
        
        let recoveryCostMap = ["high": -1.0, "medium": 0.0, "low": 1.0]
        let recoveryCost = recoveryCostMap[exercise.recoveryCost] ?? 0.0
        
        var genderModifier = 1.0
        if context.gender == "female" && (exercise.name.lowercased().contains("glute") || exercise.name.lowercased().contains("hamstring")) {
            genderModifier = 1.2
        }
        
        return (compoundBonus + noveltyFactor + recoveryCost) * weaknessMultiplier * genderModifier
    }

    // MARK: - Mesocycle Generation Logic
    
    struct VolumeLandmarks {
        let mev, mav, mrv, mv: Int
    }

    func getVolumeLandmarks(muscleGroup: String, trainingFrequency: Int = 2) -> VolumeLandmarks {
        let taf = calculateTAF()
        let rcs = calculateRCS()
        let base_mev: Double
        switch muscleGroup {
            case "chest": base_mev = Double(userProfile.mevChest)
            case "back": base_mev = Double(userProfile.mevBack)
            case "shoulders": base_mev = Double(userProfile.mevShoulders)
            case "arms": base_mev = Double(userProfile.mevArms)
            case "legs": base_mev = Double(userProfile.mevLegs)
            default: base_mev = 8.0
        }
        
        let muscle_size_factor = ["arms": 0.0, "calves": 0.0, "chest": 0.2, "shoulders": 0.2, "back": 0.4, "legs": 0.4, "glutes": 0.3, "biceps": 0.1, "triceps": 0.1, "quads": 0.3, "hamstrings": 0.2][muscleGroup] ?? 0.2
        
        let mev = base_mev * (1 + muscle_size_factor) * pow(taf, 0.3)
        let freqFactorMap = [1: 0.8, 2: 1.0, 3: 1.2, 4: 1.2, 5: 1.3, 6: 1.4]
        let trainingFrequencyFactor = freqFactorMap[trainingFrequency] ?? 1.3
        
        let mrv = mev * (2.5 + rcs) * trainingFrequencyFactor
        let mav = mev + (mrv - mev) * 0.7
        let mv = mev * 0.6
        
        return VolumeLandmarks(mev: Int(mev.rounded()), mav: Int(mav.rounded()), mrv: Int(mrv.rounded()), mv: Int(mv.rounded()))
    }
    
    func generateMesocycle(weeks: Int) -> Routine {
        let workoutSplit = getWorkoutSplit(daysPerWeek: userProfile.daysPerWeek)
        var workoutDays: [WorkoutDay] = []

        for (dayIndex, dayInfo) in workoutSplit.enumerated() {
            var weeklyExercises: [Exercise] = []
            for muscle in dayInfo.groups {
                let landmarks = getVolumeLandmarks(muscleGroup: muscle)
                let numExercises = landmarks.mev > 12 ? 3 : 2
                let selectedExercises = selectExercises(for: muscle, type: .compound, count: numExercises)
                weeklyExercises.append(contentsOf: selectedExercises)
            }
            let workoutDay = WorkoutDay(name: dayInfo.name, dayNumber: dayIndex + 1, exercises: weeklyExercises)
            workoutDays.append(workoutDay)
        }
        
        let routineName = "Generated \(userProfile.daysPerWeek)-Day Mesocycle"
        return Routine(name: routineName, primaryFocus: "Generated", daysPerWeek: userProfile.daysPerWeek, isCustom: true, workoutDays: workoutDays)
    }

    private func getWorkoutSplit(daysPerWeek: Int) -> [(name: String, groups: [String])] {
        switch daysPerWeek {
        case 3:
            return [("Full Body A", ["quads", "hamstrings", "chest", "back"]),
                    ("Full Body B", ["quads", "glutes", "shoulders", "biceps", "triceps"]),
                    ("Full Body C", ["chest", "back", "quads", "hamstrings", "calves"])]
        case 4:
            return [("Upper A", ["chest", "back", "shoulders"]),
                    ("Lower A", ["quads", "hamstrings", "glutes"]),
                    ("Upper B", ["chest", "back", "biceps", "triceps"]),
                    ("Lower B", ["quads", "hamstrings", "calves"])]
        case 5:
            return [("Push", ["chest", "shoulders", "triceps"]),
                    ("Pull", ["back", "biceps"]),
                    ("Legs", ["quads", "hamstrings", "glutes"]),
                    ("Upper", ["chest", "back", "shoulders"]),
                    ("Lower", ["quads", "hamstrings", "calves"])]
        case 6:
            return [("Push", ["chest", "shoulders", "triceps"]),
                    ("Pull", ["back", "biceps"]),
                    ("Legs", ["quads", "hamstrings", "glutes"]),
                    ("Push", ["chest", "shoulders", "triceps"]),
                    ("Pull", ["back", "biceps"]),
                    ("Legs", ["quads", "hamstrings", "calves"])]
        default:
            return [("Upper A", ["chest", "back", "shoulders"]),
                    ("Lower A", ["quads", "hamstrings", "glutes"]),
                    ("Upper B", ["chest", "back", "biceps", "triceps"]),
                    ("Lower B", ["quads", "hamstrings", "calves"])]
        }
    }
}
