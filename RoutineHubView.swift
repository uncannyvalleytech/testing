//
//  RoutineHubView.swift
//  atc
//
//  Created by Paul Allen-Howell on 9/1/25.
//

// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI

struct RoutineHubView: View {
    // We pass the routines from RoutinesView, so we don't have to query here.
    let premadeRoutines: [Routine]
    let customRoutines: [Routine]
    
    // State to control which list to display.
    @State private var showingPremadeList = false
    @State private var showingCustomList = false
    
    // State to control showing the "Create Routine" sheet.
    @State private var showingCreateSheet = false
    
    // State to control showing the "Generate Mesocycle" sheet.
    @State private var showingGenerateSheet = false

    var body: some View {
        ZStack {
            // NEW: Use the custom primary background color.
            Color.primaryBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // ADDED: A button to open the mesocycle generator.
                Button(action: { showingGenerateSheet = true }) {
                    HubOptionView(icon: "wand.and.stars", title: "Generate a Program", subtitle: "Create a personalized, long-term plan")
                }

                // NEW: Use a custom view for the "Pre-Made Templates" option.
                Button(action: { showingPremadeList = true }) {
                    HubOptionView(icon: "list.clipboard", title: "Pre-Made Templates", subtitle: "Choose from our library")
                }
                
                // ADDED: A button to view and manage user-created custom routines.
                Button(action: { showingCustomList = true }) {
                    HubOptionView(icon: "folder", title: "Your Custom Routines", subtitle: "View and edit your routines")
                }
                
                // NEW: Use a custom view for the "Create Your Own" option.
                Button(action: { showingCreateSheet = true }) {
                    HubOptionView(icon: "plus.circle", title: "Create Your Own", subtitle: "Build a routine from scratch")
                }
            }
            .padding()
            .navigationTitle("Routines") // We set the title here instead of the parent view.
            .navigationDestination(isPresented: $showingPremadeList) {
                RoutineListView(routines: premadeRoutines, title: "Pre-Made Routines")
            }
            .navigationDestination(isPresented: $showingCustomList) {
                RoutineListView(routines: customRoutines, title: "Your Custom Routines")
            }
            .sheet(isPresented: $showingCreateSheet) {
                CreateRoutineView()
            }
            .sheet(isPresented: $showingGenerateSheet) {
                GenerateMesocycleView()
            }
        }
    }
}

// SECTION 2: ROUTINELISTVIEW STRUCT (New Helper View)
struct RoutineListView: View {
    @Environment(\.modelContext) private var modelContext
    let routines: [Routine]
    let title: String
    
    @State private var showingCreateSheet = false
    
    var body: some View {
        List {
            ForEach(routines) { routine in
                NavigationLink(value: routine) {
                    VStack(alignment: .leading) {
                        Text(routine.name)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("\(routine.workoutDays?.count ?? 0) days per week")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .listRowBackground(Color.secondaryBackground)
            }
            // Enable swipe-to-delete only for custom routines.
            .onDelete(perform: title == "Your Custom Routines" ? deleteCustomRoutine : nil)
        }
        .navigationTitle(title)
        .navigationDestination(for: Routine.self) { routine in
            RoutineDetailView(routine: routine)
        }
        .toolbar {
            if title == "Your Custom Routines" {
                Button(action: { showingCreateSheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreateSheet) {
            CreateRoutineView()
        }
        .scrollContentBackground(.hidden)
    }
    
    private func deleteCustomRoutine(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(routines[index])
            }
        }
    }
}
