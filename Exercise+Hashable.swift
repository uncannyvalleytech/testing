import Foundation

// This extension makes the Exercise model conform to Hashable.
// This allows us to use an Exercise object to control the presentation of a sheet.
extension Exercise: Hashable {
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.name == rhs.name && lhs.sets == rhs.sets && lhs.targetReps == rhs.targetReps
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
