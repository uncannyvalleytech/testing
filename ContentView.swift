//
//  ContentView.swift
//  atc
//
//  Created by Paul Allen-Howell on 9/1/25.
//

// SECTION 1: IMPORTS
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var profiles: [UserProfile]
    
    // We are no longer using @AppStorage for theme, it will be handled by the new color system.
    
    // 1. Create a state object for our new view model.
    // This ensures it stays alive for the life of the app.
    @StateObject private var tabViewModel = MainTabViewModel()

    var body: some View {
        Group {
            if profiles.isEmpty {
                OnboardingView()
            } else {
                // 2. Pass the view model into the MainTabView.
                MainTabView(viewModel: tabViewModel)
            }
        }
        .onAppear {
            DataManager.loadDefaultRoutines(modelContext: modelContext)
        }
        // NEW: Apply the custom background color to the entire view.
        .background(Color.primaryBackground)
    }
}

// SECTION 2: MAINTABVIEW STRUCT
struct MainTabView: View {
    // 1. This view now observes the view model.
    @ObservedObject var viewModel: MainTabViewModel
    
    var body: some View {
        // 2. The TabView's selection is now bound to the view model's selectedTab property.
        TabView(selection: $viewModel.selectedTab) {
            HomeView(viewModel: viewModel)
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(MainTabViewModel.Tab.home) // Each tab has a unique tag.
            
            RoutinesView()
                .tabItem { Label("Routines", systemImage: "list.clipboard.fill") }
                .tag(MainTabViewModel.Tab.routines)
            
            ProgressTabView()
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }
                .tag(MainTabViewModel.Tab.progress)
            
            // FIXED: Wrap GoalsView in a NavigationStack to display the toolbar.
            NavigationStack {
                GoalsView()
            }
            .tabItem { Label("Goals", systemImage: "trophy.fill") }
            .tag(MainTabViewModel.Tab.goals)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
                .tag(MainTabViewModel.Tab.settings)
        }
        // NEW: Apply custom colors to the tab bar.
        .tint(.accentBlue)
        .preferredColorScheme(.dark)
    }
}
