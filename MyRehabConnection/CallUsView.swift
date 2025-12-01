import SwiftUI

struct CallUsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Call Us")
                .font(.largeTitle)
                .bold()
            Text("This is a placeholder for call options. You can show the clinic's phone number(s) and a button to initiate a call.")
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("Call Us")
    }
}

#Preview {
    NavigationStack {
        CallUsView()
    }
}
