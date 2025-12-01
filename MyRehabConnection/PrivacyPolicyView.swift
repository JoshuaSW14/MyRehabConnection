import SwiftUI

struct PrivacyPolicyView: View {
    var onMenuTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            MRCHeader(title: "My Rehab Connection", onMenuTapped: onMenuTapped)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sensitive Information Privacy Policy and HIPAA Compliance")
                        .font(.title2)
                        .bold()
                    Text("Last updated: August 9, 2017")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Group {
                        Text("How your information is collected?")
                            .font(.headline)
                        Text("Your first name, last name, email address and optionally a password are entered by your care provider when establishing your app login.  If a password is not set a random one is generated for you.  You may change your email address and password if desired.No other personally identifiable information is collected or made available to the app.")
                    }

                    Group {
                        Text("Do you track my usage of the app?")
                            .font(.headline)
                        Text("No. Your care provider assigns and customizes exercises for you.  We do not log your usage of the app nor do we report your usage of the app to your care provider.")
                    }

                    Group {
                        Text("How do we protect your information?")
                            .font(.headline)
                        Text("We implement a variety of security measures to maintain the safety of your personal information when you enter, submit, or access your personal information.")
                        Text("Login authentication and content (assigned exercises) are handled though a secure (encrypted) Internet connection using Secure Socket Layer (SSL) technology.  Federal HIPAA laws require that we keep this information confidential so passwords are stored with one-way encryption, which cannot be decrypted except through brute force guessing.  The private key applied to each password prior to encryption is lengthy and complex, making even the simplest of passwords nearly impossible to match.")
                    }

                    Group {
                        Text("Do we disclose any information to outside parties?")
                            .font(.headline)
                        Text("We do not sell, trade, or otherwise transfer to outside parties your personally identifiable information. This does not include trusted third parties who assist us in operating our website, conducting our business, or servicing you, so long as those parties agree to keep this information confidential. We may also release your information when we believe release is appropriate to comply with the law, enforce our site policies, or protect ours or others rights, property, or safety.")
                    }

                    Group {
                        Text("What information is saved on my phone or tablet?")
                            .font(.headline)
                        Text("Similar to how websites use cookies, all apps store some required content on your phone.  Your username and encrypted password are stored on your phone to avoid logging in each time you use the app, but logging out clears the stored password and assigned exercises.  The app saves your assigned exercises and updates the the list/steps each time you initially open the app if an Internet connection is available.  Photos of the exercise steps are saved (cached) and videos may be optionally cached to reduce bandwidth usage.  Video caching is optional and configurable by you.")
                        Text("At any point, you can clear all content from this app saved on your phone though the Settings menu of the app or by uninstalling the app.")
                        Text("Aside from cached photos (and optionally video) no information from this app is available to any other app on your phone or tablet and it does not have access to any other app data on your device.")
                    }

                    Group {
                        Text("App/Portal Privacy Policy Only")
                            .font(.headline)
                        Text("This app privacy policy applies only to information collected used by the app and clinic-facing admin portal used by your care provider, not to information collected offline.")
                    }

                    Group {
                        Text("Your Consent")
                            .font(.headline)
                        Text("By using this app, you consent to our sensitive information privacy policy.")
                    }
                }
                .padding()
            }
        }
    }
}
