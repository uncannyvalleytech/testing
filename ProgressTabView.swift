//
//  ProgressTabView.swift
//  atc
//
//  Created by Paul Allen-Howell on 9/1/25.
//

// SECTION 1: IMPORTS AND MAIN STRUCT
import SwiftUI

struct ProgressTabView: View {
    // State to manage which view is currently selected.
    @State private var selectedView: Int = 0

    var body: some View {
        ZStack {
            // NEW: Use the custom primary background color.
            Color.primaryBackground.edgesIgnoringSafeArea(.all)
            
            VStack {
                // The segmented picker to switch views.
                Picker("Progress", selection: $selectedView) {
                    Text("History").tag(0)
                    Text("Analytics").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                // NEW: Make the picker tint match the accent color.
                .tint(.accentBlue)

                // Show the selected view.
                if selectedView == 0 {
                    HistoryView()
                } else {
                    AnalyticsView()
                }
            }
        }
        // The navigation title will be set by the child view, so we don't need it here.
    }
}

// SECTION 2: PREVIEW
#Preview {
    ProgressTabView()
}
