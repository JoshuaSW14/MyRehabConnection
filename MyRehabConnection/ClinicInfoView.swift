import SwiftUI
import Foundation

struct ClinicInfoView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.openURL) private var openURL

    var onMenuTapped: () -> Void
    private var clinic: Clinic? { authManager.loginResponse?.clinic }

    private var cityProvPostal: String? {
        guard let city = clinic?.city, let prov = clinic?.provinceState, let postal = clinic?.postalZip else { return nil }
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedProv = prov.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPostal = postal.trimmingCharacters(in: .whitespacesAndNewlines)
        return "\(trimmedCity), \(trimmedProv)  \(trimmedPostal)"
    }

    private var hasAnyContactInfo: Bool {
        let phoneOK: Bool
        if let phone = clinic?.phone {
            phoneOK = !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        } else {
            phoneOK = false
        }

        let emailOK: Bool
        if let email = clinic?.email {
            emailOK = !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        } else {
            emailOK = false
        }

        let webOK: Bool
        if let website = clinic?.website {
            webOK = !website.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        } else {
            webOK = false
        }

        let faxOK: Bool
        if let fax = clinic?.fax {
            faxOK = !fax.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        } else {
            faxOK = false
        }

        let apptOK: Bool
        if let appt = clinic?.appointment {
            apptOK = !appt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        } else {
            apptOK = false
        }

        let socialsOK: Bool
        if let socials = clinic?.social {
            socialsOK = !socials.isEmpty
        } else {
            socialsOK = false
        }

        return phoneOK || emailOK || webOK || faxOK || apptOK || socialsOK
    }

    var body: some View {
        VStack(spacing: 0) {
            MRCHeader(title: "My Rehab Connection", onMenuTapped: onMenuTapped)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Clinic Card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .firstTextBaseline) {
                            Image(systemName: "building.2")
                                .foregroundStyle(.secondary)
                            Text((clinic?.name ?? "").isEmpty == false ? (clinic?.name ?? "Clinic Name") : "Clinic Name")
                                .font(.title2.weight(.semibold))
                                .foregroundStyle(.primary)
                                .lineLimit(2)
                                .minimumScaleFactor(0.9)
                        }
                        Divider()

                        if let address1 = clinic?.address1, !address1.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Text(address1)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        if let line2 = cityProvPostal, !line2.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Text(line2)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color(.systemBackground)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Contact Card
                    if hasAnyContactInfo {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Image(systemName: "person.crop.circle")
                                    .foregroundStyle(.secondary)
                                Text("Contact")
                                    .font(.title3.weight(.semibold))
                                Spacer()
                            }
                            .padding(.bottom, 8)

                            VStack(spacing: 0) {
                                if let phone = clinic?.phone, !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    contactRow(label: "Phone", value: phone, systemImage: "phone.fill") {
                                        if let url = URL(string: "tel://\(phone)") { openURL(url) }
                                    }
                                    separator()
                                }
                                if let email = clinic?.email, !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    contactRow(label: "Email", value: email, systemImage: "envelope.fill") {
                                        if let url = URL(string: "mailto:\(email)") { openURL(url) }
                                    }
                                    separator()
                                }
                                if let website = clinic?.website, !website.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    contactRow(label: "Website", value: website, systemImage: "globe") {
                                        if let url = URL(string: website) { openURL(url) }
                                    }
                                    separator()
                                }
                                if let fax = clinic?.fax, !fax.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    contactRow(label: "Fax", value: fax, systemImage: "printer.fill") {
                                        // No default action for fax
                                    }
                                    separator()
                                }
                                if let appt = clinic?.appointment, !appt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    contactRow(label: "Appointment", value: appt, systemImage: "calendar") {
                                        if let url = URL(string: appt) { openURL(url) }
                                    }
                                    if let socials = clinic?.social, !socials.isEmpty {
                                        separator()
                                    }
                                }
                                if let socials = clinic?.social {
                                    let filtered = socials.filter { !$0.type.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !$0.url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                                    ForEach(Array(filtered.enumerated()), id: \.offset) { index, link in
                                        contactRow(label: link.type, value: link.url, systemImage: "link") {
                                            if let url = URL(string: link.url) { openURL(url) }
                                        }
                                        if index < filtered.count - 1 { separator() }
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color(.systemBackground)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)
                    }

                    // Hours Card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundStyle(.secondary)
                            Text("Hours")
                                .font(.title3.weight(.semibold))
                            Spacer()
                        }

                        if let hours = clinic?.hours, !hours.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            if let attributed = htmlToAttributedString(hours) {
                                Text(attributed)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                Text(stripHTML(hours))
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        } else {
                            Text("Closed")
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color(.systemBackground)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
                .padding(.top, 12)
            }
            .background(Color(.systemGroupedBackground))
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private func contactRow(label: String, value: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 22)
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(value)
                        .font(.body)
                        .foregroundStyle(.blue)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label) \(value)")
    }

    @ViewBuilder
    private func separator() -> some View {
        Divider()
            .overlay(Color.secondary.opacity(0.2))
            .padding(.leading, 34) // align under icon
    }

    @ViewBuilder
    private func hoursRow(day: String, hours: String?) -> some View {
        HStack {
            Text(day)
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text((hours?.isEmpty == false ? hours! : "Closed"))
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal)
    }

    // MARK: - Helpers
    private func htmlToAttributedString(_ html: String) -> AttributedString? {
        let data = Data(html.utf8)
        if let attributed = try? NSAttributedString(data: data,
                                                    options: [.documentType: NSAttributedString.DocumentType.html,
                                                              .characterEncoding: String.Encoding.utf8.rawValue],
                                                    documentAttributes: nil) {
            return AttributedString(attributed)
        }
        return nil
    }

    private func stripHTML(_ html: String) -> String {
        html
            .replacingOccurrences(of: "<br>", with: "\n")
            .replacingOccurrences(of: "<br />", with: "\n")
            .replacingOccurrences(of: "<br/>", with: "\n")
            .replacingOccurrences(of: "</tr>", with: "\n")
            .replacingOccurrences(of: "</td>", with: "\t")
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
