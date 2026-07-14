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
    
    
    @State private var dateOfBirth = Date()
    @StateObject private var editProfileVM = EditProfileViewModel()
    @State private var showSuccessAlert = false

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
                        prefixImage: "person"
                    )


                    Text("Gender")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    Menu {
                        Button("Male") {
                            gender = "Male"
                        }

                        Button("Female") {
                            gender = "Female"
                        }

                    } label: {

                        HStack {

                            Image("gender")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)

                            Text(gender.isEmpty ? "Select Gender" : gender)
                                .foregroundColor(gender.isEmpty ? .gray : .white)
                                .font(.custom("Inter18pt-Regular", size: 16))

                            Spacer()

                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 64)
                        .background(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                        )
                    }
                    

                    
                    Text("Date of Birth")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    HStack(spacing: 16) {

                        Image("calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)

                        DatePicker(
                            "",
                            selection: $dateOfBirth,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .colorScheme(.dark)

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 64)
                    .background(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                    )
                     
                    Text("Blood Group")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    Menu {

                        Button("A+") {
                            bloodGroup = "A+"
                        }

                        Button("A-") {
                            bloodGroup = "A-"
                        }

                        Button("B+") {
                            bloodGroup = "B+"
                        }

                        Button("B-") {
                            bloodGroup = "B-"
                        }

                        Button("AB+") {
                            bloodGroup = "AB+"
                        }

                        Button("AB-") {
                            bloodGroup = "AB-"
                        }

                        Button("O+") {
                            bloodGroup = "O+"
                        }

                        Button("O-") {
                            bloodGroup = "O-"
                        }

                    } label: {

                        HStack(spacing: 16) {

                            Image("blood_group")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)

                            Text(bloodGroup.isEmpty ? "Select Blood Group" : bloodGroup)
                                .font(.custom("Inter18pt-Regular", size: 16))
                                .foregroundColor(bloodGroup.isEmpty ? .gray : .white)

                            Spacer()

                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 64)
                        .background(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                        )
                    }
                    
                    
                    

                    Text("Height")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    CustomTextField(
                        text: $height,
                        placeholder: "Enter height",
                        prefixImage: "height"
                    )

                    Text("Weight")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    CustomTextField(
                        text: $weight,
                        placeholder: "Enter weight",
                        prefixImage: "weight"
                    )

                    Text("Emergency Contact")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    CustomTextField(
                        text: $emergencyContact,
                        placeholder: "Enter emergency contact",
                        prefixImage: "telephone",
                        keyboardType: .phonePad
                    )

                    Text("Medical History")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    ZStack(alignment: .topLeading) {

                        if medicalHistory.isEmpty {
                            Text("Enter medical history")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 16)
                        }

                        TextEditor(text: $medicalHistory)
                            .frame(height: 120)
                            .padding(8)
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                    }
                    .background(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                    )

                    PrimaryButton(title: "Save") {
                        //print("Hello")
                        
                        editProfileVM.updateProfile(
                                name: name,
                                gender: gender.lowercased(),
                                dateOfBirth: formattedDate,
                                bloodGroup: bloodGroup,
                                height: Double(height) ?? 0.0,
                                weight: Double(weight) ?? 0.0,
                                emergencyContact: emergencyContact,
                                medicalHistory: medicalHistory
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
        .onChange(of: editProfileVM.isProfileUpdated) { success in
            if success {
                
                showSuccessAlert = true
                
                //print("✅ Profile Updated Successfully")
                // Optionally pop back or show a success toast/alert
            }
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

