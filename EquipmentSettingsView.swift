import SwiftUI
import SwiftData

struct EquipmentSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    // We receive the user's profile to read and write their available equipment.
    @Bindable var userProfile: UserProfile

    // We generate the master list of all possible equipment from the WorkoutEngine.
    private let allEquipment: [String]
    
    // We use a temporary state variable to hold the user's selections in the UI.
    @State private var selectedEquipment: Set<String>

    init(userProfile: UserProfile) {
        self.userProfile = userProfile
        let engine = WorkoutEngine(userProfile: userProfile)
        
        // Initialize the state from the profile's saved equipment.
        _selectedEquipment = State(initialValue: Set(userProfile.availableEquipment))
        
        // Get all unique equipment options from the database.
        var equipmentSet = Set<String>()
        engine.exerciseDatabase.values.flatMap { $0 }.forEach { exercise in
            exercise.equipment.forEach { equipmentSet.insert($0) }
        }
        self.allEquipment = Array(equipmentSet).sorted()
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                // A flexible grid to display all the equipment options.
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(allEquipment, id: \.self) { equipment in
                        Button(action: {
                            toggleSelection(for: equipment)
                        }) {
                            Text(equipment.replacingOccurrences(of: "_", with: " ").capitalized)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedEquipment.contains(equipment) ? Color.blue : Color(.secondarySystemGroupedBackground))
                                .foregroundColor(selectedEquipment.contains(equipment) ? .white : .primary)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Your Equipment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: saveEquipment)
                }
            }
        }
    }

    private func toggleSelection(for equipment: String) {
        if selectedEquipment.contains(equipment) {
            selectedEquipment.remove(equipment)
        } else {
            selectedEquipment.insert(equipment)
        }
    }
    
    private func saveEquipment() {
        // When the user saves, update the actual UserProfile with the new selections.
        userProfile.availableEquipment = Array(selectedEquipment)
        dismiss()
    }
}
