//
//  SettingsView.swift
//  atc
//
//  Created by Paul Allen-Howell on 9/1/25.
//

// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var profiles: [UserProfile]
    private var userProfile: UserProfile? { profiles.first }
    
    // We no longer use @AppStorage for the theme, as it's now managed by the overall app's color scheme.
    @AppStorage("weightUnit") private var weightUnit: String = "lbs"
    
    @State private var showingDeleteAlert = false
    @State private var showingEquipmentSheet = false

    var body: some View {
        NavigationStack {
            // THE FIX: We apply a background that fills the entire space
            // and uses a material that respects the current color scheme.
            ZStack {
                // NEW: Use the custom background color.
                Color.primaryBackground.edgesIgnoringSafeArea(.all)
                
                Form {
                    Section(header: Text("Appearance").foregroundColor(.white)) {
                        // The Picker is now a custom view.
                        HStack {
                            Text("Theme")
                            Spacer()
                            Text("Dark")
                                .foregroundColor(.accentBlue)
                        }
                    }
                    
                    Section(header: Text("Workout Preferences").foregroundColor(.white)) {
                        Picker("Units", selection: $weightUnit) {
                            Text("Pounds (lbs)").tag("lbs")
                            Text("Kilograms (kg)").tag("kg")
                        }
                        .tint(.accentBlue) // NEW: Apply the vibrant accent color to the picker.
                        
                        Button("Manage Equipment") {
                            showingEquipmentSheet = true
                        }
                        .foregroundColor(.accentBlue) // NEW: Apply the vibrant accent color to the button.
                    }
                    
                    Section(header: Text("Data Management").foregroundColor(.white)) {
                        Button("Delete All My Data", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    }
                }
                // NEW: Make the list background transparent and apply a custom background to rows.
                .scrollContentBackground(.hidden)
                .listRowBackground(Color.secondaryBackground)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            // NEW: Set the navigation bar title color.
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.secondaryBackground, for: .navigationBar)
            .alert("Are you sure?", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive, action: deleteAllData)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will permanently delete all your user data. This action cannot be undone.")
            }
            .sheet(isPresented: $showingEquipmentSheet) {
                if let profile = userProfile {
                    EquipmentSettingsView(userProfile: profile)
                }
            }
        }
    }
    
    private func deleteAllData() {
        try? modelContext.delete(model: UserProfile.self)
    }
}
