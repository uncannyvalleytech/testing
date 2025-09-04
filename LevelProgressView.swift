// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI

struct LevelProgressView: View {
    let level: Int
    let currentXP: Int
    let xpToNextLevel: Int

    // Calculate the progress for the bar (a value between 0.0 and 1.0).
    private var progress: Double {
        // Ensure we don't divide by zero.
        guard xpToNextLevel > 0 else { return 0 }
        // We use the modulo operator (%) to get the XP for the current level.
        return Double(currentXP % xpToNextLevel) / Double(xpToNextLevel)
    }
    
    // A dictionary to get a title for each level.
    private var levelTitle: String {
        let titles = [
            1: "Fitness Novice", 2: "Training Apprentice", 3: "Gym Regular",
            4: "Strength Seeker", 5: "Fitness Enthusiast", 6: "Training Warrior",
            7: "Muscle Builder", 8: "Strength Master", 9: "Fitness Legend", 10: "Iron Champion"
        ]
        return titles[level] ?? "Level \(level) Master"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header with level and title.
            HStack {
                Text("Level \(level)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white) // NEW: Set color for visibility.
                Text(levelTitle)
                    .font(.subheadline)
                    .foregroundColor(.gray) // NEW: Use a muted color.
            }
            
            // The visual progress bar.
            ProgressView(value: progress)
                .tint(.neonGreen) // NEW: Sets the color of the progress bar to a vibrant green.
            
            // Text showing the numerical XP progress.
            Text("\(currentXP % xpToNextLevel) / \(xpToNextLevel) XP")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(Color.secondaryBackground) // NEW: Use the custom secondary background.
        .cornerRadius(16)
    }
}

// SECTION 2: PREVIEW
#Preview {
    LevelProgressView(level: 5, currentXP: 4200, xpToNextLevel: 1000)
}
