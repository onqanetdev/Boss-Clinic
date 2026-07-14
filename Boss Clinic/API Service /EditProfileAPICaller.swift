//
//  EditProfileAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 14/07/26.
//

import Foundation



class EditProfileAPICaller {

    static let shared = EditProfileAPICaller()

    func updateProfile(
        name: String,
        gender: String,
        dateOfBirth: String,
        bloodGroup: String,
        height: Double,
        weight: Double,
        emergencyContact: String,
        medicalHistory: String,
        completion: @escaping (Result<ProfileEditModel, NetworkError>) -> Void
    ) {

        let urlString = baseURL + APIEndpoint.profile.rawValue

        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }

        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            completion(.failure(.validationError("Access Token not found.")))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "name": name,
            "gender": gender,
            "date_of_birth": dateOfBirth,
            "blood_group": bloodGroup,
            "height": Double(height) ?? 0.0,
            "weight": Double(weight) ?? 0.0,
            "emergency_contact": emergencyContact,
            "medical_history": medicalHistory
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                print("❌ EDIT PROFILE ERROR: \(error.localizedDescription)")

                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }

                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  let data = data else {

                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }

                return
            }

            print("📌 EDIT PROFILE STATUS CODE: \(httpResponse.statusCode)")

            if let json = String(data: data, encoding: .utf8) {
                print("📌 EDIT PROFILE RESPONSE: \(json)")
            }

            if (200...299).contains(httpResponse.statusCode) {

                do {

                    let response = try JSONDecoder().decode(ProfileEditModel.self, from: data)

                    DispatchQueue.main.async {
                        completion(.success(response))
                    }

                } catch {

                    print("❌ DECODING ERROR: \(error.localizedDescription)")

                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                }

            } else if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {

                DispatchQueue.main.async {
                    completion(.failure(.validationError(errorResponse.message ?? "Something went wrong.")))
                }

            } else {

                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
            }

        }.resume()
    }
}


