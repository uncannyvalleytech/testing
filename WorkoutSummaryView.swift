//
//  WorkoutSummaryView.swift
//  atc
//
//  Created by Paul Allen-Howell on 9/1/25.
//

import SwiftUI
import SwiftData

struct WorkoutSummaryView: View {
    @Query private var profiles: [UserProfile]
    private var userProfile: UserProfile? { profiles.first }
    
    let workoutHistory: WorkoutHistory
    let newlyCompletedGoal: Goal?
    let onContinue: () -> Void
    
    private var xpGained: Int {
        Int(workoutHistory.totalVolume / 100.0)
    }

    var body: some View {
        ZStack {
            Color.primaryBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer()
                
                Text("Workout Complete!")
                    .font(.largeTitle).fontWeight(.bold)
                    .foregroundColor(.white)

                if let goal = newlyCompletedGoal {
                    VStack(spacing: 8) {
                        Text("🏆 Goal Achieved!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                        Text("You hit your goal for **\(goal.exercise)**:")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Text("**\(String(format: "%.0f", goal.targetWeight)) lbs x \(goal.targetReps) reps**")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondaryBackground)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.yellow, lineWidth: 2)
                    )
                }
                
                Text("+\(xpGained) XP")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.neonGreen)

                VStack(spacing: 16) {
                    StatView(label: "Total Volume", value: "\(Int(workoutHistory.totalVolume)) lbs")
                    StatView(label: "Duration", value: formatDuration(seconds: workoutHistory.durationInSeconds))
                    StatView(label: "Exercises", value: "\(workoutHistory.exercises?.count ?? 0)")
                }
                .padding().background(Color.secondaryBackground).cornerRadius(16)

                Spacer()

                Button(action: {
                    if let profile = userProfile {
                        profile.totalXP += xpGained
                        profile.level = (profile.totalXP / 1000) + 1
                    }
                    onContinue()
                }) {
                    Text("Continue")
                        .fontWeight(.semibold).frame(maxWidth: .infinity)
                        .padding().background(Color.accentBlue)
                        .foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }

    func formatDuration(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return "\(minutes)m \(remainingSeconds)s"
    }
}

struct StatView: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label).foregroundColor(.gray)
            Spacer()
            Text(value).fontWeight(.bold).foregroundColor(.white)
        }
    }
}
