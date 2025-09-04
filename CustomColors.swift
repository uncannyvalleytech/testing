//
//  CustomColors.swift
//  atc
//
//  Created by Paul Allen-Howell on 9/1/25.
//

// SECTION 1: IMPORTS
import SwiftUI

// SECTION 2: CUSTOM COLOR EXTENSION
extension Color {
    static let primaryBackground = Color(red: 0.05, green: 0.05, blue: 0.15)
    static let secondaryBackground = Color(red: 0.15, green: 0.15, blue: 0.25)
    static let accentBlue = Color(red: 0.1, green: 0.6, blue: 1.0)
    static let neonGreen = Color(red: 0.2, green: 0.8, blue: 0.6)
    static let purpleGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.4, green: 0.2, blue: 0.6), Color(red: 0.6, green: 0.4, blue: 0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
