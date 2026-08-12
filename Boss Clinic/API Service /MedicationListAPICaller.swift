//
//  MedicationListAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 16/07/26.
//

import Foundation


class MedicationListAPICaller {

    static let shared = MedicationListAPICaller()

    func fetchMedicationList(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<ActiveMedicationResponse, NetworkError>) -> Void
    ) {

        // ✅ Internet check
        guard NetworkMonitor.shared.isConnected else {
            DispatchQueue.main.async {
                completion(.failure(.noInternet))
            }
            return
        }

        let urlString = baseURL + APIEndpoint.medication.rawValue

        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }

        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            SessionManager.shared.logout()
            completion(.failure(.validationError("Access Token not found.")))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "page": page,
            "per_page": perPage
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                print("❌ MEDICATION LIST ERROR: \(error.localizedDescription)")

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

            print("📌 MEDICATION LIST STATUS CODE: \(httpResponse.statusCode)")

            if let json = String(data: data, encoding: .utf8) {
               // print("📌 MEDICATION LIST RESPONSE: \(json)")
            }

            switch httpResponse.statusCode {

            case 200...299:

                do {

                    let response = try JSONDecoder().decode(
                        ActiveMedicationResponse.self,
                        from: data
                    )

                    DispatchQueue.main.async {
                        completion(.success(response))
                    }

                } catch {

                    print("❌ DECODING ERROR: \(error.localizedDescription)")

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

                    let message = errorResponse.message ?? "Something went wrong."

                    DispatchQueue.main.async {
                        completion(.failure(.validationError(message)))
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
