//
//  NotificationCountAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 24/07/26.
//

import Foundation



class NotificationCountAPICaller {

    static let shared = NotificationCountAPICaller()

    func fetchNotificationCount(
        completion: @escaping (Result<NotificationCountResponse, NetworkError>) -> Void
    ) {

        let urlString = baseURL + APIEndpoint.notificationCount.rawValue

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

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                print("❌ NOTIFICATION COUNT ERROR: \(error.localizedDescription)")

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

            print("📌 NOTIFICATION COUNT STATUS CODE: \(httpResponse.statusCode)")

            if let json = String(data: data, encoding: .utf8) {
                print("📌 NOTIFICATION COUNT RESPONSE: \(json)")
            }

            switch httpResponse.statusCode {

            case 200...299, 404:

                do {

                    let response = try JSONDecoder().decode(
                        NotificationCountResponse.self,
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



