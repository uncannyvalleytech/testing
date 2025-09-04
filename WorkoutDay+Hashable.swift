import Foundation

// By adding this extension, we make the existing WorkoutDay model conform to Hashable.
// This allows us to use it as a navigation destination item.
extension WorkoutDay: Hashable {
    static func == (lhs: WorkoutDay, rhs: WorkoutDay) -> Bool {
        return lhs.name == rhs.name && lhs.dayNumber == rhs.dayNumber
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(dayNumber)
    }
}
