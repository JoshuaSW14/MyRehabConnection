import SwiftUI

struct MapDirectionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Map & Directions")
                .font(.largeTitle)
                .bold()
            Text("This is a placeholder for maps and directions. Integrate MapKit or link to Apple Maps here.")
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("Directions")
    }
}

#Preview {
    NavigationStack {
        MapDirectionsView()
    }
}
