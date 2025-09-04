import Foundation
import SwiftData

@MainActor
class DataManager {
    
    static func loadDefaultRoutines(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<Routine>()
        guard let count = try? modelContext.fetchCount(descriptor), count == 0 else {
            print("Default routines already loaded.")
            return
        }
        
        print("Loading all default routines for the first time.")
        
        // MARK: - Pre-made Routines Data Structure
        let premadeRoutines: [(name: String, focus: String, daysPerWeek: Int, workouts: [(dayName: String, exercises: [(name: String, sets: Int, reps: String, group: String)])])] = [
            // Beginner Programs
            (
                name: "Beginner Full Body A/B", focus: "Full Body", daysPerWeek: 2, workouts: [
                    ("Workout A", [
                        ("Barbell Squat", 3, "8-10", "quads"),
                        ("Barbell Bench Press", 3, "8-10", "chest"),
                        ("Bent Over Barbell Row", 3, "8-10", "back"),
                        ("Leg Press", 2, "10-12", "quads"),
                        ("Plank", 3, "30-60s", "abs")
                    ]),
                    ("Workout B", [
                        ("Barbell Deadlift", 3, "6-8", "back"),
                        ("Overhead Press", 3, "8-10", "shoulders"),
                        ("Lat Pulldown", 3, "8-10", "back"),
                        ("Dumbbell Lunges", 2, "10-12", "quads"),
                        ("Lying Leg Raises", 3, "12-15", "abs")
                    ])
                ]
            ),
            (
                name: "Beginner Dumbbell Full Body", focus: "Full Body", daysPerWeek: 2, workouts: [
                    ("Workout A", [
                        ("Goblet Squat", 3, "10-15", "quads"),
                        ("Push-ups", 3, "AMRAP", "chest"),
                        ("Dumbbell Romanian Deadlift", 3, "10-15", "hamstrings"),
                        ("Renegade Row", 3, "8-10", "back"),
                        ("Dumbbell Overhead Press", 3, "10-12", "shoulders"),
                        ("Dumbbell Bicep Curls", 3, "12-15", "biceps")
                    ]),
                    ("Workout B", [
                        ("Dumbbell Reverse Lunge", 3, "10-12", "quads"),
                        ("Dumbbell Floor Press", 3, "10-15", "chest"),
                        ("Glute Bridge", 3, "15-20", "glutes"),
                        ("Bent-Over Dumbbell Row", 3, "10-15", "back"),
                        ("Dumbbell Lateral Raises", 3, "15-20", "shoulders"),
                        ("Bench Dips", 3, "AMRAP", "triceps")
                    ])
                ]
            ),
            
            // Intermediate Programs
            (
                name: "Intermediate Upper/Lower (2-Day)", focus: "Upper/Lower", daysPerWeek: 2, workouts: [
                    ("Upper", [
                        ("Barbell Bench Press", 3, "6-10", "chest"),
                        ("Bent Over Row", 3, "6-10", "back"),
                        ("Seated Dumbbell Shoulder Press", 3, "10-12", "shoulders"),
                        ("Lat Pulldown", 3, "10-12", "back"),
                        ("Dumbbell Lateral Raise", 2, "12-15", "shoulders"),
                        ("Barbell Curl", 2, "12-15", "biceps"),
                        ("Triceps Rope Pushdown", 2, "12-15", "triceps")
                    ]),
                    ("Lower", [
                        ("Barbell Squat", 3, "6-10", "quads"),
                        ("Romanian Deadlift", 3, "8-10", "hamstrings"),
                        ("Leg Press", 3, "10-12", "quads"),
                        ("Lying Leg Curl", 3, "12-15", "hamstrings"),
                        ("Standing Calf Raise", 3, "15-20", "calves"),
                        ("Cable Crunch", 3, "15-20", "abs")
                    ])
                ]
            ),
            (
                name: "Intermediate Push/Pull/Legs", focus: "PPL", daysPerWeek: 3, workouts: [
                    ("Push", [
                        ("Barbell Bench Press", 3, "6-10", "chest"),
                        ("Seated Dumbbell Shoulder Press", 3, "8-12", "shoulders"),
                        ("Incline Dumbbell Press", 3, "8-12", "chest"),
                        ("Lateral Raise", 2, "12-15", "shoulders"),
                        ("Triceps Rope Pushdown", 2, "12-15", "triceps")
                    ]),
                    ("Pull", [
                        ("Deadlifts", 3, "5-8", "back"),
                        ("Pull-ups", 3, "8-10", "back"),
                        ("Seated Cable Row", 3, "10-12", "back"),
                        ("Face Pulls", 2, "15-20", "shoulders"),
                        ("Barbell Bicep Curls", 2, "12-15", "biceps")
                    ]),
                    ("Legs", [
                        ("Barbell Squats", 3, "6-10", "quads"),
                        ("Romanian Deadlifts", 3, "10-12", "hamstrings"),
                        ("Leg Press", 3, "10-12", "quads"),
                        ("Leg Curls", 2, "12-15", "hamstrings"),
                        ("Calf Raises", 3, "15-20", "calves")
                    ])
                ]
            ),
            (
                name: "Intermediate Upper/Lower Split (4-Day)", focus: "Upper/Lower", daysPerWeek: 4, workouts: [
                    ("Upper Body Strength", [
                        ("Barbell Bench Press", 4, "4-6", "chest"),
                        ("Weighted Pull-ups", 4, "4-6", "back"),
                        ("Seated Barbell Overhead Press", 3, "6-8", "shoulders"),
                        ("Barbell Row", 3, "6-8", "back"),
                        ("Close-Grip Bench Press", 3, "6-8", "triceps")
                    ]),
                    ("Lower Body Strength", [
                        ("Barbell Back Squat", 4, "4-6", "quads"),
                        ("Conventional Deadlift", 3, "4-6", "back"),
                        ("Leg Press", 3, "6-8", "quads"),
                        ("Barbell Hip Thrust", 3, "6-8", "glutes"),
                        ("Weighted Crunches", 3, "8-12", "abs")
                    ]),
                    ("Upper Body Hypertrophy", [
                        ("Incline Dumbbell Press", 4, "8-12", "chest"),
                        ("Lat Pulldown", 4, "8-12", "back"),
                        ("Seated Dumbbell Lateral Raise", 3, "10-15", "shoulders"),
                        ("Seated Cable Row", 3, "10-12", "back"),
                        ("Dumbbell Skullcrushers", 3, "10-15", "triceps"),
                        ("Dumbbell Bicep Curls", 3, "10-15", "biceps")
                    ]),
                    ("Lower Body Hypertrophy", [
                        ("Goblet Squat", 4, "10-15", "quads"),
                        ("Romanian Deadlift", 4, "10-12", "hamstrings"),
                        ("Bulgarian Split Squat", 3, "10-12", "glutes"),
                        ("Leg Extension", 3, "12-15", "quads"),
                        ("Lying Leg Curl", 4, "12-15", "hamstrings"),
                        ("Standing Calf Raise", 4, "15-20", "calves")
                    ])
                ]
            ),
            
            // Advanced Programs
            (
                name: "Classic 5-Day Body Part Split", focus: "Body Part", daysPerWeek: 5, workouts: [
                    ("Chest", [
                        ("Incline Barbell Bench Press", 4, "8-12", "chest"),
                        ("Flat Dumbbell Bench Press", 3, "8-10", "chest"),
                        ("Chest Dip (Weighted)", 3, "8-12", "chest"),
                        ("Dumbbell Flyes", 3, "10-15", "chest"),
                        ("Incline Push-ups", 3, "Failure", "chest")
                    ]),
                    ("Back", [
                        ("Wide Grip Pull-up (Weighted)", 4, "6-10", "back"),
                        ("Bent-Over Barbell Row", 4, "8-10", "back"),
                        ("Seated Cable Row", 3, "10-12", "back"),
                        ("Lat Pulldown", 3, "10-12", "back"),
                        ("Machine Reverse Fly", 3, "12-15", "back")
                    ]),
                    ("Shoulders", [
                        ("Seated Dumbbell Press", 4, "8-12", "shoulders"),
                        ("One-Arm Cable Lateral Raise", 3, "12-15", "shoulders"),
                        ("Barbell Front Raise", 3, "10-12", "shoulders"),
                        ("Face Pulls", 4, "15-20", "shoulders"),
                        ("Dumbbell Shrugs", 4, "10-12", "shoulders")
                    ]),
                    ("Legs", [
                        ("Barbell Squat", 4, "8-10", "quads"),
                        ("Leg Press", 3, "12-15", "quads"),
                        ("Romanian Deadlift", 4, "10-12", "hamstrings"),
                        ("Seated Leg Curl", 3, "12-15", "hamstrings"),
                        ("Standing Calf Raise", 5, "10-15", "calves")
                    ]),
                    ("Arms & Abs", [
                        ("Close Grip Bench Press", 4, "8-10", "triceps"),
                        ("Barbell Curl", 4, "8-10", "biceps"),
                        ("Tricep Overhead Extension", 3, "10-12", "triceps"),
                        ("Incline Dumbbell Curl", 3, "10-12", "biceps"),
                        ("Tricep Kickback", 3, "12-15", "triceps"),
                        ("Hammer Curl", 3, "12-15", "biceps"),
                        ("Hanging Leg Raise", 4, "Failure", "abs")
                    ])
                ]
            ),
            (
                name: "The Nippard Hybrid Split", focus: "Hybrid", daysPerWeek: 5, workouts: [
                    ("Upper Body (Strength)", [
                        ("Incline Bench Press", 3, "6-8", "chest"),
                        ("Weighted Pull-up", 3, "6-8", "back"),
                        ("Seated Dumbbell Press", 3, "8-10", "shoulders"),
                        ("Pendlay Row", 3, "6-8", "back"),
                        ("Overhead Cable Tricep Extension", 2, "8-10", "triceps"),
                        ("Cable Bicep Curl", 2, "8-10", "biceps")
                    ]),
                    ("Lower Body (Strength)", [
                        ("Barbell Back Squat", 4, "5-7", "quads"),
                        ("Romanian Deadlift", 3, "8-10", "hamstrings"),
                        ("Leg Press", 3, "10-12", "quads"),
                        ("Seated Calf Raise", 4, "10-12", "calves")
                    ]),
                    ("Push (Hypertrophy)", [
                        ("Dumbbell Bench Press", 4, "10-12", "chest"),
                        ("Seated Cable Fly", 3, "12-15", "chest"),
                        ("Cable Lateral Raise", 4, "12-15", "shoulders"),
                        ("Triceps Pushdown", 3, "12-15", "triceps")
                    ]),
                    ("Pull (Hypertrophy)", [
                        ("Lat Pulldown (Neutral Grip)", 4, "10-12", "back"),
                        ("Machine Row", 3, "12-15", "back"),
                        ("Face Pulls", 4, "15-20", "shoulders"),
                        ("Preacher Curls", 3, "12-15", "biceps")
                    ]),
                    ("Legs (Hypertrophy)", [
                        ("Barbell Hip Thrust", 4, "10-12", "glutes"),
                        ("Bulgarian Split Squat", 3, "12-15", "glutes"),
                        ("Lying Leg Curl", 4, "12-15", "hamstrings"),
                        ("Leg Extension", 3, "15-20", "quads"),
                        ("Standing Calf Raise", 4, "15-20", "calves")
                    ])
                ]
            ),
            
            // Women's Focused Programs
            (
                name: "Women's Upper/Lower (Strength)", focus: "Upper/Lower", daysPerWeek: 4, workouts: [
                    ("Upper Body Strength", [
                        ("Machine Press", 4, "6", "chest"),
                        ("Dumbbell Row", 4, "6", "back"),
                        ("Shoulder Press", 4, "6", "shoulders"),
                        ("Lat Pulldown", 4, "6", "back"),
                        ("Hyperextensions", 3, "12-15", "back")
                    ]),
                    ("Lower Body Strength", [
                        ("Smith Machine Squat", 4, "6", "quads"),
                        ("Deadlift", 4, "6", "back"),
                        ("Reverse Lunges", 4, "6", "glutes"),
                        ("Leg Press", 4, "6", "quads"),
                        ("Hip Thrust", 4, "6", "glutes")
                    ]),
                    ("Upper Body Hypertrophy", [
                        ("Incline Dumbbell Press", 3, "12", "chest"),
                        ("Seated Cable Row", 3, "12", "back"),
                        ("Seated Dumbbell Press", 3, "12", "shoulders"),
                        ("Lat Pulldown", 3, "12", "back"),
                        ("Dumbbell Bicep Curl", 2, "12", "biceps"),
                        ("Tricep Extensions", 2, "12", "triceps")
                    ]),
                    ("Lower Body Hypertrophy", [
                        ("Goblet Squat", 3, "12", "quads"),
                        ("Dumbbell RDL", 3, "12", "hamstrings"),
                        ("Bulgarian Split Squat", 3, "12", "glutes"),
                        ("Hack Squat", 3, "12", "quads"),
                        ("Abduction Machine", 3, "15-20", "glutes")
                    ])
                ]
            ),
            
            // 5-Day Women's Program
            (
                name: "5-Day Women's Program", focus: "Body Part", daysPerWeek: 5, workouts: [
                    ("Legs (Quad Focus)", [
                        ("Squat", 4, "6-12", "quads"),
                        ("Leg Press", 3, "12-15", "quads"),
                        ("Dumbbell Lunge", 3, "12-15", "quads"),
                        ("Leg Extensions", 3, "12-15", "quads")
                    ]),
                    ("Back & Biceps", [
                        ("Lat Pulldowns", 4, "6-12", "back"),
                        ("One Arm Dumbbell Row", 3, "12-15", "back"),
                        ("Seated Cable Row", 3, "12-15", "back"),
                        ("Dumbbell Curl & Tricep Extension", 3, "12", "biceps")
                    ]),
                    ("Glutes & Hamstrings", [
                        ("Barbell Hip Thrust", 4, "6-12", "glutes"),
                        ("Romanian Deadlift", 3, "12-15", "hamstrings"),
                        ("Glute Cable Kickback", 3, "12-15", "glutes"),
                        ("Smith Machine Sumo Squats", 3, "8-12", "glutes")
                    ]),
                    ("Chest & Shoulders", [
                        ("Dumbbell Bench Press", 4, "6-12", "chest"),
                        ("Incline Dumbbell Press", 3, "12-15", "chest"),
                        ("Seated Dumbbell Press", 4, "6-12", "shoulders"),
                        ("Lateral Raise", 3, "12-15", "shoulders")
                    ]),
                    ("Full Lower & Arms", [
                        ("Deadlifts", 4, "6-12", "back"),
                        ("Good Mornings", 3, "12-15", "hamstrings"),
                        ("Incline Curl & Skullcrusher", 3, "12", "biceps"),
                        ("Cable Curl & Pressdown", 3, "15", "biceps")
                    ])
                ]
            )
        ]
        
        // MARK: - Loop and Insert Data
        for routineData in premadeRoutines {
            let routine = Routine(name: routineData.name, primaryFocus: routineData.focus, daysPerWeek: routineData.daysPerWeek, isCustom: false)
            modelContext.insert(routine)
            
            var workoutDays: [WorkoutDay] = []
            for (index, workoutData) in routineData.workouts.enumerated() {
                let workoutDay = WorkoutDay(name: workoutData.dayName, dayNumber: index + 1)
                
                var exercises: [Exercise] = []
                for exerciseData in workoutData.exercises {
                    let exercise = Exercise(name: exerciseData.name, sets: exerciseData.sets, targetReps: exerciseData.reps, muscleGroup: exerciseData.group)
                    exercises.append(exercise)
                }
                workoutDay.exercises = exercises
                workoutDay.routine = routine
                workoutDays.append(workoutDay)
            }
            routine.workoutDays = workoutDays
        }
        
        // Save context
        try? modelContext.save()
        print("Successfully loaded \(premadeRoutines.count) default routines")
    }
}
