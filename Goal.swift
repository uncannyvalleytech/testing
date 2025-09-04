import Foundation
import SwiftData

@Model
final class Goal {
    var id: UUID
    var exercise: String
    var targetWeight: Double
    var targetReps: Int
    var startDate: Date
    var isCompleted: Bool

    init(id: UUID = UUID(), exercise: String, targetWeight: Double, targetReps: Int, startDate: Date = Date(), isCompleted: Bool = false) {
        self.id = id
        self.exercise = exercise
        self.targetWeight = targetWeight
        self.targetReps = targetReps
        self.startDate = startDate
        self.isCompleted = isCompleted
    }
}
