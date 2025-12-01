import SwiftUI

struct MakeAppointmentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Make Appointment")
                .font(.largeTitle)
                .bold()
            Text("This is a placeholder for booking appointments. Integrate your scheduling flow or web view here.")
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("Appointment")
    }
}

#Preview {
    NavigationStack {
        MakeAppointmentView()
    }
}
