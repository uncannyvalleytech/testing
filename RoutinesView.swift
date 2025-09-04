//
//  RoutinesView.swift
//  atc
//
//  Created by Paul Allen-Howell on 9/1/25.
//

// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI
import SwiftData

struct RoutinesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Routine.name) private var routines: [Routine]
    
    // NEW: The state variable to control the creation sheet.
    @State private var showingCreateSheet = false
    
    // Private computed properties to separate routine types, now used by the hub view.
    private var premadeRoutines: [Routine] { routines.filter { !$0.isCustom } }
    private var customRoutines: [Routine] { routines.filter { $0.isCustom } }
    
    var body: some View {
        // The NavigationStack provides a navigation context for the hub.
        NavigationStack {
            // The view's body now uses the RoutineHubView, passing the queried and filtered routines.
            RoutineHubView(premadeRoutines: premadeRoutines, customRoutines: customRoutines)
        }
    }
    
    // The function to handle the deletion.
    private func deleteCustomRoutine(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(customRoutines[index])
            }
        }
    }
}
