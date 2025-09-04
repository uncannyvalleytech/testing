import Foundation
import SwiftData

// This model represents a single, completed workout session.
@Model
final class WorkoutHistory {
    var id: UUID
    var date: Date
    var name: String
    var durationInSeconds: Int
    var totalVolume: Double
    
    // A session has many completed exercises.
    @Relationship(deleteRule: .cascade, inverse: \CompletedExercise.session)
    var exercises: [CompletedExercise]?

    init(id: UUID = UUID(), date: Date, name: String, durationInSeconds: Int, totalVolume: Double) {
        self.id = id
        self.date = date
        self.name = name
        self.durationInSeconds = durationInSeconds
        self.totalVolume = totalVolume
    }
}

// This model stores the details of a single exercise within a completed session.
@Model
final class CompletedExercise {
    var name: String
    var muscleGroup: String
    
    // An exercise has many completed sets.
    @Relationship(deleteRule: .cascade, inverse: \CompletedSet.exercise)
    var sets: [CompletedSet]?
    
    // The session this exercise belongs to.
    var session: WorkoutHistory?

    init(name: String, muscleGroup: String) {
        self.name = name
        self.muscleGroup = muscleGroup
    }
}

// This model stores the data for a single set (weight, reps, etc.).
@Model
final class CompletedSet {
    var weight: Double
    var reps: Int
    var rir: Int // Reps in Reserve
    
    var exercise: CompletedExercise?

    init(weight: Double, reps: Int, rir: Int) {
        self.weight = weight
        self.reps = reps
        self.rir = rir
    }
}
