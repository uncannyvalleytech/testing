import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID
    var onboardingComplete: Bool
    var availableEquipment: [String]
    var currentWeek: Int
    var totalXP: Int
    var level: Int
    var mevChest: Int
    var mevBack: Int
    var mevShoulders: Int
    var mevArms: Int
    var mevLegs: Int
    var sex: String
    var age: Int
    
    // Add these new properties for the next steps
    var trainingMonths: Int
    var sleepHours: Double
    var stressLevel: Int
    var daysPerWeek: Int
    var goal: String

    init() {
        self.id = UUID()
        self.onboardingComplete = false
        self.availableEquipment = [
            "barbell", "dumbbell", "cable", "machine", "bodyweight", "bench",
            "adjustable_bench", "pullup_bar", "dip_station", "rack", "plate", "kettlebell"
        ]
        self.currentWeek = 1
        self.totalXP = 0
        self.level = 1
        self.mevChest = 8
        self.mevBack = 10
        self.mevShoulders = 8
        self.mevArms = 6
        self.mevLegs = 14
        self.sex = "male"
        self.age = 25
        
        // Add their initial values here
        self.trainingMonths = 6
        self.sleepHours = 8.0
        self.stressLevel = 5
        self.daysPerWeek = 4
        self.goal = "hypertrophy"
    }
}
