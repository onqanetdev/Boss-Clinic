//
//  MyProfileScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 07/07/26.
//

import SwiftUI

struct MyProfileScreen: View {

    @State var name = ""
    @State var gender = ""
    // @State private var dateOfBirth = ""
    @State var bloodGroup = ""
    @State var height = ""
    @State var weight = ""
    @State var emergencyContact = ""
    @State var medicalHistory = ""
    
    @State var emailId = ""
    
    @State private var dateOfBirth = Date()
    @StateObject private var editProfileVM = EditProfileViewModel()
    @State private var showSuccessAlert = false
    @State private var dateSelected = false

    @State var selectedAddress = ""
    @State private var showOfflineAlert = false
    
    var body: some View {

        
        ZStack {
            
            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 20) {

                    Text("Name")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    CustomTextField(
                        text: $name,
                        placeholder: "Enter your name",
                        prefixImage: "user"
                    )


                    
                    Text("Email")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    CustomTextField(
                        text: $emailId,
                        placeholder: "Enter your email",
                        prefixImage: "mailbox"
                    )

                   //MARK: Gender Selection
                    
                    
                    
                    Text("Gender")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    CustomDropdown(
                        selection: $gender,
                        placeholder: "Male/Female/Other",
                        options: ["Male", "Female", "Other"]
                    )

                    
                
                    Text("Address")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    CustomDropdown(
                        selection: $selectedAddress,
                        placeholder: "Select clinic",
                        options: ["Subiaco-Clinic-WA", "Bondi-Clinic-NSW"]
                    )
                    
                    
                    Text("Phone")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    CustomTextField(
                        text: $emergencyContact,
                        placeholder: "Enter emergency contact",
                        prefixImage: "telephone",
                        keyboardType: .phonePad
                    )


                    PrimaryButton(title: "Save") {
                        //print("Hello")
                        
                        editProfileVM.updateProfile(
                                name: name,
                                gender: gender.lowercased(),
                                phoneReceived: emergencyContact,
                                address: selectedAddress.lowercased()
                            )
                        
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical)
            }
            
            // Loader
                  if editProfileVM.isLoading {

                      Color.black.opacity(0.4)
                          .ignoresSafeArea()

                      ProgressView()
                          .progressViewStyle(.circular)
                          .tint(.white)
                          .scaleEffect(1.5)
                  }
            
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("My Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: dateOfBirth) { _ in
            dateSelected = true
        }
        .onChange(of: editProfileVM.isProfileUpdated) { success in
            if success {
                
                showSuccessAlert = true
                
                //print("✅ Profile Updated Successfully")
                // Optionally pop back or show a success toast/alert
            }
        }
        .onChange(of: editProfileVM.isOffline) { offline in
            if offline {
                showOfflineAlert = true
            }
        }
        .alert("No Internet Connection", isPresented: $showOfflineAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please check your internet connection and try again.")
        }
        .alert(
            "Error",
            isPresented: Binding(
                get: { editProfileVM.errorMessage != nil },
                set: { _ in editProfileVM.errorMessage = nil }
            )
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(editProfileVM.errorMessage ?? "")
        }
        
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Profile updated successfully.")
        }
    }
    
    
    private var displayDate: String {

//            guard let date = dateOfBirth else {
//                return ""
//            }

            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"

            return formatter.string(from: dateOfBirth)
        }
    
    
    private var formattedDate: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: dateOfBirth)
        }
    
}

#Preview {
    NavigationStack {
        MyProfileScreen()
    }
}

