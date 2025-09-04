//
//  AnalyticsView.swift
//  atc
//
//  Created by Paul Allen-Howell on 9/1/25.
//

// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI
import SwiftData
import Charts

struct AnalyticsView: View {
    @Query(sort: \WorkoutHistory.date, order: .forward) private var workoutHistory: [WorkoutHistory]

    private var totalWorkouts: Int {
        workoutHistory.count
    }
    
    private var totalVolume: Double {
        workoutHistory.reduce(0) { $0 + $1.totalVolume }
    }
    
    private var averageDuration: Int {
        guard !workoutHistory.isEmpty else { return 0 }
        let totalSeconds = workoutHistory.reduce(0) { $0 + $1.durationInSeconds }
        return (totalSeconds / workoutHistory.count) / 60
    }

    var body: some View {
        // NEW: The background is now the vibrant primary color.
        ZStack {
            Color.primaryBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Lifetime Stats Section
                    VStack(alignment: .leading) {
                        Text("Lifetime Stats")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white) // NEW: Set text color for visibility.
                        
                        HStack(spacing: 16) {
                            StatCard(value: "\(totalWorkouts)", label: "Workouts")
                            StatCard(value: "\(Int(totalVolume))", label: "Total Volume (lbs)")
                            StatCard(value: "\(averageDuration) min", label: "Avg. Duration")
                        }
                    }
                    
                    // Workout Volume Chart Section
                    VStack(alignment: .leading) {
                        Text("Workout Volume Over Time")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white) // NEW: Set text color for visibility.
                        
                        Chart(workoutHistory) { session in
                            BarMark(
                                x: .value("Date", session.date, unit: .day),
                                y: .value("Volume", session.totalVolume)
                            )
                            // NEW: Use the custom accent color.
                            .foregroundStyle(Color.accentBlue.gradient)
                        }
                        .frame(height: 250)
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .weekOfYear)) { _ in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel(format: .dateTime.month().day())
                            }
                        }
                        .padding()
                        // NEW: Use the custom secondary background.
                        .background(Color.secondaryBackground)
                        .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Analytics")
    }
}

// SECTION 2: STATCARD STRUCT
struct StatCard: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white) // NEW: Set text color for visibility.
            Text(label)
                .font(.caption)
                .foregroundColor(.gray) // NEW: Use a muted color.
        }
        .frame(maxWidth: .infinity)
        .padding()
        // NEW: Use the custom secondary background.
        .background(Color.secondaryBackground)
        .cornerRadius(12)
    }
}

// SECTION 3: PREVIEW
#Preview {
    let container = try! ModelContainer(for: WorkoutHistory.self, configurations: .init(isStoredInMemoryOnly: true))
    let date = Date()
    container.mainContext.insert(WorkoutHistory(date: date.addingTimeInterval(-86400 * 14), name: "Workout 1", durationInSeconds: 3600, totalVolume: 12000))
    container.mainContext.insert(WorkoutHistory(date: date.addingTimeInterval(-86400 * 7), name: "Workout 2", durationInSeconds: 4200, totalVolume: 15000))
    container.mainContext.insert(WorkoutHistory(date: date, name: "Workout 3", durationInSeconds: 3900, totalVolume: 14000))
    
    return NavigationStack {
        AnalyticsView()
            .modelContainer(container)
    }
}
