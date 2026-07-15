//
//  ContactUsScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 15/07/26.
//

import SwiftUI

struct ContactUsScreen: View {

    @State private var name = ""
    @State private var email = ""
    @State private var message = ""

    @State private var nameError: String?
    @State private var emailError: String?
    @State private var messageError: String?

    @State private var showSuccessAlert = false

    @StateObject private var contactVM = ContactUsViewModel()

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 20) {

                    Text("Contact Us")
                        .font(.custom("Inter24pt-Bold", size: 28))
                        .foregroundColor(.white)

                    Text("Have a question or feedback? We'd love to hear from you.")
                        .font(.custom("Inter18pt-Regular", size: 15))
                        .foregroundColor(.gray)

                    // MARK: Name

                    Text("Name")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    CustomTextField(
                        text: $name,
                        placeholder: "Enter your name",
                        prefixImage: "person"
                    )

                    if let nameError {
                        Text(nameError)
                            .font(.custom("Inter18pt-Regular", size: 12))
                            .foregroundColor(.red)
                    }

                    // MARK: Email

                    Text("Email")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    CustomTextField(
                        text: $email,
                        placeholder: "Enter your email",
                        prefixImage: "email",
                        keyboardType: .emailAddress,
                        textContentType: .emailAddress
                    )

                    if let emailError {
                        Text(emailError)
                            .font(.custom("Inter18pt-Regular", size: 12))
                            .foregroundColor(.red)
                    }

                    // MARK: Message

                    Text("Message")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    ZStack(alignment: .topLeading) {

                        if message.isEmpty {

                            Text("Write your message...")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 16)
                        }

                        TextEditor(text: $message)
                            .frame(height: 180)
                            .padding(8)
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                    }
                    .background(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                    )

                    if let messageError {
                        Text(messageError)
                            .font(.custom("Inter18pt-Regular", size: 12))
                            .foregroundColor(.red)
                    }

                    PrimaryButton(title: "Send Message") {

                        nameError = nil
                        emailError = nil
                        messageError = nil

                        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
                            nameError = "Please enter your name."
                            return
                        }

                        guard isValidEmail(email) else {
                            emailError = "Please enter a valid email address."
                            return
                        }

                        guard !message.trimmingCharacters(in: .whitespaces).isEmpty else {
                            messageError = "Please enter your message."
                            return
                        }

                        contactVM.sendMessage(
                            name: name,
                            email: email,
                            message: message
                        )
                    }
                    .padding(.top, 20)

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }

            // MARK: Loader

            if contactVM.isLoading {

                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .navigationTitle("Contact Us")
        .navigationBarTitleDisplayMode(.inline)

        .onChange(of: contactVM.isMessageSent) { success in
            if success {

                showSuccessAlert = true

                name = ""
                email = ""
                message = ""
            }
        }

        .alert(
            "Error",
            isPresented: Binding(
                get: { contactVM.errorMessage != nil },
                set: { _ in contactVM.errorMessage = nil }
            )
        ) {

            Button("OK", role: .cancel) { }

        } message: {

            Text(contactVM.errorMessage ?? "")
        }

        .alert("Success", isPresented: $showSuccessAlert) {

            Button("OK") { }

        } message: {

            Text("Your message has been sent successfully.")
        }
    }

    private func isValidEmail(_ email: String) -> Bool {

        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"

        return NSPredicate(format: "SELF MATCHES %@", emailRegex)
            .evaluate(with: email)
    }
}

#Preview {

    NavigationStack {

        ContactUsScreen()
    }
}
