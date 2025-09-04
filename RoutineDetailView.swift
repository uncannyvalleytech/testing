//
//  RoutineDetailView.swift
//  atc
//
//  Created by Paul Allen-Howell on 9/1/25.
//

// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI
import SwiftData

struct RoutineDetailView: View {
    let routine: Routine

    var body: some View {
        ZStack {
            // NEW: Use the custom primary background color.
            Color.primaryBackground.edgesIgnoringSafeArea(.all)
            
            List {
                ForEach(routine.workoutDays?.sorted(by: { $0.dayNumber < $1.dayNumber }) ?? []) { workoutDay in
                    WorkoutDaySectionView(workoutDay: workoutDay)
                        // NEW: Make the list background transparent.
                        .listRowBackground(Color.secondaryBackground)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(routine.name)
        // NEW: Set navigation bar colors.
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.secondaryBackground, for: .navigationBar)
        .navigationDestination(for: WorkoutDay.self) { workoutDay in
            WorkoutSessionView(workoutDay: workoutDay)
        }
    }
}

// SECTION 2: WORKOUTDAYSECTIONVIEW STRUCT
struct WorkoutDaySectionView: View {
    let workoutDay: WorkoutDay
    
    var body: some View {
        Section(header: Text("Day \(workoutDay.dayNumber): \(workoutDay.name)").foregroundColor(.white)) { // NEW: Set color for visibility.
            ForEach(workoutDay.exercises ?? []) { exercise in
                VStack(alignment: .leading) {
                    Text(exercise.name).fontWeight(.bold).foregroundColor(.white) // NEW: Set color for visibility.
                    Text("\(exercise.sets) sets of \(exercise.targetReps)")
                        .font(.caption).foregroundColor(.gray) // NEW: Use a muted color.
                }
                .padding(.vertical, 4)
            }
            
            NavigationLink(value: workoutDay) {
                Text("Start Workout for this Day")
                    .fontWeight(.bold).foregroundColor(.accentBlue) // NEW: Use the vibrant accent color.
            }
        }
    }
}
