import SwiftUI

struct EmailUsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Email Us")
                .font(.largeTitle)
                .bold()
            Text("This is a placeholder for email options. You can present a mail composer or show contact addresses.")
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("Email Us")
    }
}

#Preview {
    NavigationStack {
        EmailUsView()
    }
}
