//
//  MedicationTypeAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/10/26.
//

import Foundation




//enum MedicationTypeAPIError: LocalizedError {
//    case offline
//    case invalidURL
//    case invalidResponse
//    case unauthorized
//    case serverError(Int)
//
//    var errorDescription: String? {
//        switch self {
//        case .offline:
//            return "No internet connection."
//        case .invalidURL:
//            return "Invalid URL."
//        case .invalidResponse:
//            return "Invalid response from server."
//        case .unauthorized:
//            return "Your session has expired. Please log in again."
//        case .serverError(let code):
//            return "Something went wrong (\(code)). Please try again."
//        }
//    }
//}

class MedicationTypeAPICaller {

    private let urlString = "https://a.bossclinic.com.au/api/patient-medication-type"

    func fetchMedicationTypes(completion: @escaping (Result<MedicationTypeResponse, Error>) -> Void) {

        guard NetworkMonitor.shared.isConnected else {
            print("❌ No internet connection")
            DispatchQueue.main.async {
                completion(.failure(MedicationTypeAPIError.offline))
            }
            return
        }

        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            DispatchQueue.main.async {
                completion(.failure(MedicationTypeAPIError.invalidURL))
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            print("❌ Access Token not found")
        }

        print("📌 GET \(urlString)")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("❌ Medication Type Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                print("❌ Invalid response")
                DispatchQueue.main.async {
                    completion(.failure(MedicationTypeAPIError.invalidResponse))
                }
                return
            }

            print("📌 Medication Type Status Code: \(httpResponse.statusCode)")

            switch httpResponse.statusCode {

            case 200...299:
                print("📌 Medication Type Raw Response: \(String(data: data, encoding: .utf8) ?? "")")
                do {
                    let decoded = try JSONDecoder().decode(MedicationTypeResponse.self, from: data)
                    print("✅ Medication Types: \(decoded.data.count) loaded")
                    DispatchQueue.main.async {
                        completion(.success(decoded))
                    }
                } catch {
                    print("❌ Medication Type Decoding Error: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }

            case 401:
                print("❌ Unauthorized — logging out")
                DispatchQueue.main.async {
                    SessionManager.shared.logout()
                    completion(.failure(MedicationTypeAPIError.unauthorized))
                }

            default:
                let body = String(data: data, encoding: .utf8) ?? ""
                print("❌ Medication Type Server Error \(httpResponse.statusCode): \(body)")
                DispatchQueue.main.async {
                    completion(.failure(MedicationTypeAPIError.serverError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
}
