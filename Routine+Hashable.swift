import Foundation

// This extension makes the Routine model conform to Hashable.
// This is required for value-based NavigationLinks to work correctly.
extension Routine: Hashable {
    static func == (lhs: Routine, rhs: Routine) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
