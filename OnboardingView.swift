// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext

    // State variable to track which onboarding screen we're on
    @State private var currentStep = 0

    // State variables to hold the data for all onboarding steps
    @State private var sex: String = "male"
    @State private var age: String = "25"
    @State private var trainingMonths: String = "6"
    @State private var sleepHours: Double = 8.0
    @State private var stressLevel: Double = 5.0
    @State private var daysPerWeek: Int = 4
    @State private var goal: String = "hypertrophy"

    var body: some View {
        ZStack {
            // NEW: Use the custom primary background color.
            Color.primaryBackground.edgesIgnoringSafeArea(.all)
            
            VStack {
                // This shows a progress bar at the top
                ProgressView(value: Double(currentStep), total: 4)
                    .padding(.vertical)
                    .tint(.accentBlue) // NEW: Apply the vibrant accent color to the progress bar.

                // Switch between views based on the current step
                if currentStep == 0 {
                    aboutYouStep
                } else if currentStep == 1 {
                    experienceStep
                } else if currentStep == 2 {
                    lifestyleStep
                } else if currentStep == 3 {
                    availabilityStep
                } else if currentStep == 4 {
                    goalStep
                }

                Spacer()
                
                // Navigation buttons at the bottom
                HStack {
                    if currentStep > 0 {
                        Button("Back") {
                            currentStep -= 1
                        }
                        .padding()
                        .foregroundColor(.accentBlue) // NEW: Use the accent color for the button.
                    }
                    
                    Button(currentStep == 4 ? "Finish" : "Next") {
                        if currentStep == 4 {
                            saveProfile()
                        } else {
                            currentStep += 1
                        }
                    }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentBlue) // NEW: Use the accent color for the button background.
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
            // Animate the transition between steps
            .animation(.default, value: currentStep)
        }
    }

    // MARK: - Onboarding Steps (Sub-views)
    var aboutYouStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("About You").font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
            Text("This helps us calculate your baseline recovery.").foregroundColor(.gray)
            Picker("Biological Sex", selection: $sex) {
                Text("Male").tag("male")
                Text("Female").tag("female")
            }
            .pickerStyle(.segmented)
            .background(Color.secondaryBackground) // NEW: Use a custom background color for the segmented picker.
            .cornerRadius(8)
            .foregroundColor(.white)
            TextField("Age", text: $age)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.secondaryBackground) // NEW: Use a custom background color for the text field.
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    var experienceStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Your Experience").font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
            Text("How many months have you been training consistently?").foregroundColor(.gray)
            TextField("Months", text: $trainingMonths)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.secondaryBackground)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    var lifestyleStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Lifestyle Factors").font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
            Text("Your recovery is influenced by sleep and stress.").foregroundColor(.gray)
            
            VStack {
                Text("Average Sleep: \(sleepHours, specifier: "%.1f") hours").foregroundColor(.white)
                Slider(value: $sleepHours, in: 4...12, step: 0.5)
                    .tint(.accentBlue) // NEW: Use the vibrant accent color for the slider.
            }
            
            VStack {
                Text("Average Stress: \(stressLevel, specifier: "%.0f") / 10").foregroundColor(.white)
                Slider(value: $stressLevel, in: 1...10, step: 1)
                    .tint(.accentBlue)
            }
        }
    }
    
    var availabilityStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Training Availability").font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
            Text("How many days per week can you train?").foregroundColor(.gray)
            Picker("Days", selection: $daysPerWeek) {
                Text("3 Days").tag(3)
                Text("4 Days").tag(4)
                Text("5 Days").tag(5)
                Text("6 Days").tag(6)
            }
            .pickerStyle(.segmented)
            .background(Color.secondaryBackground)
            .cornerRadius(8)
            .foregroundColor(.white)
        }
    }

    var goalStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Primary Goal").font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
            Text("This helps us tailor your training focus.").foregroundColor(.gray)
            Picker("Goal", selection: $goal) {
                Text("Build Muscle").tag("hypertrophy")
                Text("Get Stronger").tag("strength")
                Text("Fat Loss").tag("fatLoss")
            }
            .pickerStyle(.segmented)
            .background(Color.secondaryBackground)
            .cornerRadius(8)
            .foregroundColor(.white)
        }
    }

    // MARK: - Save Function
    func saveProfile() {
        let newProfile = UserProfile()
        newProfile.sex = self.sex
        newProfile.age = Int(self.age) ?? 25
        newProfile.trainingMonths = Int(self.trainingMonths) ?? 6
        newProfile.sleepHours = self.sleepHours
        newProfile.stressLevel = Int(self.stressLevel)
        newProfile.daysPerWeek = self.daysPerWeek
        newProfile.goal = self.goal
        newProfile.onboardingComplete = true // Mark onboarding as complete!
        
        modelContext.insert(newProfile)
    }
}

// SECTION 2: PREVIEW
#Preview {
    let container = try! ModelContainer(for: UserProfile.self, configurations: .init(isStoredInMemoryOnly: true))
    return OnboardingView()
        .modelContainer(container)
}
