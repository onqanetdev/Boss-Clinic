//
//  NotificationAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 21/07/26.
//

import Foundation


class NotificationAPICaller {

    static let shared = NotificationAPICaller()

    func fetchNotifications(
        completion: @escaping (Result<NotificationResponse, NetworkError>) -> Void
    ) {

        let urlString = baseURL + APIEndpoint.notificationList.rawValue

        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            // Token is invalid/expired — clear it and kick the user back to login.
            SessionManager.shared.logout()
        }

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                print("❌ NOTIFICATION ERROR: \(error.localizedDescription)")

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

            print("📌 NOTIFICATION STATUS CODE: \(httpResponse.statusCode)")

            if let json = String(data: data, encoding: .utf8) {
                print("📌 NOTIFICATION RESPONSE: \(json)")
            }

            if (200...299).contains(httpResponse.statusCode) ||
                httpResponse.statusCode == 404 {

                do {

                    let response = try JSONDecoder().decode(NotificationResponse.self, from: data)

                    DispatchQueue.main.async {
                        completion(.success(response))
                    }

                } catch {

                    print("❌ DECODING ERROR: \(error.localizedDescription)")

                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                }

            } else if httpResponse.statusCode == 401 {
                // Token is invalid/expired — clear it and kick the user back to login.
                SessionManager.shared.logout()
                

                DispatchQueue.main.async {
                    completion(.failure(.unauthorized))
                }

            } else {

                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
            }

        }.resume()
    }
}


