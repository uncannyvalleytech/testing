// SECTION 1: IMPORTS
import SwiftUI

// SECTION 2: HUBOPTIONVIEW STRUCT
struct HubOptionView: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            // NEW: Updated to use a custom semi-transparent background and a vibrant icon.
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color.accentBlue.opacity(0.8))
                .cornerRadius(10)

            VStack(alignment: .leading) {
                Text(title).font(.headline).fontWeight(.bold)
                Text(subtitle).font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        // NEW: Updated to use the custom secondary background color and rounded corners.
        .background(Color.secondaryBackground)
        .cornerRadius(16)
        .foregroundColor(.primary)
    }
}

// SECTION 3: PREVIEW
#Preview {
    HubOptionView(icon: "figure.walk", title: "Sample Title", subtitle: "Sample subtitle text")
        .padding()
}
