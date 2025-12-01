import SwiftUI

struct WebsiteView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Our Website")
                .font(.largeTitle)
                .bold()
            Text("This is a placeholder for showing the clinic website. Consider embedding a web view or deep-linking to Safari.")
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("Website")
    }
}

#Preview {
    NavigationStack {
        WebsiteView()
    }
}
