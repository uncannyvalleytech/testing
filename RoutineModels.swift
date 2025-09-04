import Foundation
import SwiftData

// This model represents a complete routine or template, like "Beginner Full Body".
@Model
final class Routine {
    @Attribute(.unique) var id: UUID
    var name: String
    var primaryFocus: String
    var daysPerWeek: Int
    var isCustom: Bool
    
    // This creates a one-to-many relationship. One Routine can have many WorkoutDays.
    // The .cascade rule means if you delete a Routine, all its associated days are also deleted.
    @Relationship(deleteRule: .cascade, inverse: \WorkoutDay.routine)
    var workoutDays: [WorkoutDay]?

    init(id: UUID = UUID(), name: String, primaryFocus: String, daysPerWeek: Int, isCustom: Bool = false, workoutDays: [WorkoutDay] = []) {
        self.id = id
        self.name = name
        self.primaryFocus = primaryFocus
        self.daysPerWeek = daysPerWeek
        self.isCustom = isCustom
        self.workoutDays = workoutDays
    }
}

// This model represents a single day within a routine, like "Workout A" or "Push Day".
@Model
final class WorkoutDay {
    var name: String
    var dayNumber: Int // e.g., Day 1, Day 2
    
    @Relationship(deleteRule: .cascade, inverse: \Exercise.workoutDay)
    var exercises: [Exercise]?
    
    // This establishes the many-to-one relationship back to the Routine.
    var routine: Routine?

    init(name: String, dayNumber: Int, exercises: [Exercise] = []) {
        self.name = name
        self.dayNumber = dayNumber
        self.exercises = exercises
    }
}

// This model represents a single exercise within a workout day.
@Model
final class Exercise {
    var name: String
    var sets: Int
    var targetReps: String
    var muscleGroup: String
    
    var workoutDay: WorkoutDay?

    init(name: String, sets: Int, targetReps: String, muscleGroup: String) {
        self.name = name
        self.sets = sets
        self.targetReps = targetReps
        self.muscleGroup = muscleGroup
    }
}
