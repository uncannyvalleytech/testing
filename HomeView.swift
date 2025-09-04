//
//  HomeView.swift
//  atc
//
//  Created by Paul Allen-Howell on 9/1/25.
//

// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI
import SwiftData

struct HomeView: View {
    // 1. This view now observes the shared view model.
    @ObservedObject var viewModel: MainTabViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(getGreeting())
                    .font(.largeTitle).fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                NavigationLink(destination: StartWorkoutView()) {
                    HubOptionView(icon: "figure.walk", title: "Start Workout", subtitle: "Begin your training session")
                }
                
                // CHANGED: The "Routines" link now goes to the main RoutinesView, which acts as a hub.
                NavigationLink(destination: RoutinesView()) {
                    HubOptionView(icon: "list.clipboard", title: "Routines", subtitle: "View templates or create your own")
                }
                
                // REMOVED: The redundant "Create a Routine" button has been removed.
                
                Button(action: { viewModel.selectedTab = .progress }) {
                    HubOptionView(icon: "chart.bar", title: "Progress", subtitle: "Track your journey")
                }
                
                Button(action: { viewModel.selectedTab = .goals }) {
                    HubOptionView(icon: "trophy", title: "Goals", subtitle: "Set and track your goals")
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Home")
            .navigationBarHidden(true)
        }
    }

    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good morning!" }
        else if hour < 18 { return "Good afternoon!" }
        else { return "Good evening!" }
    }
}
