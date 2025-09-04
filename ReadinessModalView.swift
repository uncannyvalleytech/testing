import SwiftUI

struct ReadinessModalView: View {
    @Environment(\.dismiss) private var dismiss
    
    // This view will receive a closure to execute when the user submits their readiness.
    let onSubmit: (ReadinessData) -> Void

    // A simple struct to hold the readiness data, just like your JavaScript object.
    struct ReadinessData {
        var sleepQuality: Double = 7
        var energyLevel: Double = 7
        var motivation: Double = 7
        var muscleSoreness: Double = 3
    }

    @State private var readinessData = ReadinessData()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Daily Readiness")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("How are you feeling today? This helps us adjust your workout for the best results.")
                    .foregroundColor(.secondary)
                
                // Sliders for user input.
                VStack {
                    Text("Sleep Quality: \(readinessData.sleepQuality, specifier: "%.0f") / 10")
                    Slider(value: $readinessData.sleepQuality, in: 1...10, step: 1)
                }
                
                VStack {
                    Text("Energy Level: \(readinessData.energyLevel, specifier: "%.0f") / 10")
                    Slider(value: $readinessData.energyLevel, in: 1...10, step: 1)
                }
                
                VStack {
                    Text("Motivation: \(readinessData.motivation, specifier: "%.0f") / 10")
                    Slider(value: $readinessData.motivation, in: 1...10, step: 1)
                }
                
                VStack {
                    Text("Muscle Soreness: \(readinessData.muscleSoreness, specifier: "%.0f") / 10")
                    Slider(value: $readinessData.muscleSoreness, in: 1...10, step: 1)
                }

                Spacer()

                Button("Start Adjusted Workout") {
                    // When tapped, call the onSubmit closure with the collected data.
                    onSubmit(readinessData)
                    dismiss() // Close the modal.
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Skip & Use Planned Workout") {
                    dismiss() // Just close the modal without submitting data.
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 5)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}
