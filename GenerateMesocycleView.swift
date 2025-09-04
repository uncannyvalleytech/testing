//
//  GenerateMesocycleView.swift
//  atc
//
//  Created by Paul Allen-Howell on 9/2/25.
//

import SwiftUI
import SwiftData

struct GenerateMesocycleView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var profiles: [UserProfile]
    
    @State private var mesocycleWeeks: Double = 4.0

    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryBackground.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Generate a New Program")
                        .font(.largeTitle).fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Based on your profile, we'll create a personalized, long-term training plan for you.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Program Duration (Weeks)")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("\(Int(mesocycleWeeks)) weeks")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.accentBlue)
                        
                        Slider(value: $mesocycleWeeks, in: 3...8, step: 1)
                            .tint(.accentBlue)
                    }
                    .padding()
                    .background(Color.secondaryBackground)
                    .cornerRadius(16)
                    
                    Button(action: generateAndSaveMesocycle) {
                        Text("Generate My Program")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentBlue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Program Generator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.accentBlue)
                }
            }
        }
    }

    private func generateAndSaveMesocycle() {
        guard let userProfile = profiles.first else {
            // Handle error: No user profile found
            return
        }
        
        let engine = WorkoutEngine(userProfile: userProfile)
        let newRoutine = engine.generateMesocycle(weeks: Int(mesocycleWeeks))
        
        modelContext.insert(newRoutine)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            // Handle save error
            print("Failed to save the generated mesocycle: \(error)")
        }
    }
}

#Preview {
    GenerateMesocycleView()
}
