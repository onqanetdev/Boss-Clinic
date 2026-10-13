//
//  AddMedicationAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/10/26.
//

import Foundation





class AddMedicationAPICaller {

    static let shared = AddMedicationAPICaller()

    /// `medicines` is the array that goes under the "medicines" key, e.g.
    /// [{ "name", "medicine_type", "dose", "strength", "frequency",
    ///    "times", "start_date", "end_date", "taken_day_stock" }]
    func addMedications(
        medicines: [[String: Any]],
        completion: @escaping (Result<AddMedicationResponse, NetworkError>) -> Void
    ) {

        // ✅ Internet check
        guard NetworkMonitor.shared.isConnected else {
            DispatchQueue.main.async {
                completion(.failure(.noInternet))
            }
            return
        }

        let urlString = baseURL + APIEndpoint.patientAddMedication.rawValue

        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }

        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            // Token is invalid/expired — clear it and kick the user back to login.
            SessionManager.shared.logout()
            completion(.failure(.validationError("Access Token not found.")))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "medicines": medicines
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            print("📌 ADD MEDICATION BODY: \(bodyString)")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                print("❌ ADD MEDICATION ERROR: \(error.localizedDescription)")

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

            print("📌 ADD MEDICATION STATUS CODE: \(httpResponse.statusCode)")

            if let json = String(data: data, encoding: .utf8) {
                print("📌 ADD MEDICATION RESPONSE: \(json)")
            }

            switch httpResponse.statusCode {

            case 200...299:

                do {

                    let response = try JSONDecoder().decode(AddMedicationResponse.self, from: data)

                    print("✅ ADD MEDICATION: \(response.message)")

                    DispatchQueue.main.async {
                        completion(.success(response))
                    }

                } catch {

                    print("❌ DECODING ERROR: \(error)")

                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                }

            case 401:

                // Token is invalid/expired — clear it and kick the user back to login.
                SessionManager.shared.logout()

                DispatchQueue.main.async {
                    completion(.failure(.validationError("Session expired. Please login again.")))
                }

            default:

                if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {

                    DispatchQueue.main.async {
                        completion(.failure(.validationError(errorResponse.message ?? "Something went wrong.")))
                    }

                } else {

                    DispatchQueue.main.async {
                        completion(.failure(.serverError))
                    }
                }
            }

        }.resume()
    }
}

