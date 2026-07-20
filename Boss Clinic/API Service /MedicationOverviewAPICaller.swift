//
//  MedicationOverviewAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 20/07/26.
//

import Foundation





class MedicationOverviewAPICaller {

    static let shared = MedicationOverviewAPICaller()

    func fetchMedicationOverview(
        type: String,
        page: Int = 1,
        perPage: Int = 10,
        completion: @escaping (Result<Any, NetworkError>) -> Void
    ) {

        let urlString = baseURL + APIEndpoint.medicationOverview.rawValue

        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }

        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            completion(.failure(.validationError("Access Token not found.")))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // MARK: - Multipart Form Data

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        func append(_ key: String, _ value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        append("type", type)
        append("per_page", "\(perPage)")
        append("page", "\(page)")

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                print("❌ MEDICATION OVERVIEW ERROR: \(error.localizedDescription)")

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

            print("📌 STATUS CODE: \(httpResponse.statusCode)")

//            if let json = String(data: data, encoding: .utf8) {
//                print("📌 RESPONSE: \(json)")
//            }

            switch httpResponse.statusCode {

            case 200...299:

                do {

                    let decoder = JSONDecoder()

                    if type == "history" {

                        let response = try decoder.decode(
                            MedicationHistoryResponse.self,
                            from: data
                        )

                        DispatchQueue.main.async {
                            completion(.success(response))
                        }

                    } else {

                        let response = try decoder.decode(
                            UpcomingMedicationResponse.self,
                            from: data
                        )

                        DispatchQueue.main.async {
                            completion(.success(response))
                        }
                    }

                } catch {

                    print("❌ DECODING ERROR: \(error)")

                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                }

            case 401:

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



