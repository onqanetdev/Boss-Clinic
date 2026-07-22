//
//  NotificationSettingsAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 17/07/26.
//

import Foundation



class NotificationSettingsAPICaller {

    static let shared = NotificationSettingsAPICaller()

    func fetchNotificationSettings(
        completion: @escaping (Result<NotificationSettingsResponse, NetworkError>) -> Void
    ) {

        let urlString = baseURL + APIEndpoint.notificationSettings.rawValue

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
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                print("❌ NOTIFICATION SETTINGS ERROR: \(error.localizedDescription)")

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

            print("📌 NOTIFICATION SETTINGS STATUS CODE: \(httpResponse.statusCode)")

            if let json = String(data: data, encoding: .utf8) {
                print("📌 NOTIFICATION SETTINGS RESPONSE: \(json)")
            }

            switch httpResponse.statusCode {

            case 200...299:

                do {

                    let response = try JSONDecoder().decode(
                        NotificationSettingsResponse.self,
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
                    // Token is invalid/expired — clear it and kick the user back to login.
                    SessionManager.shared.logout()
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

