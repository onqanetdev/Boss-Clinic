//
//  NotificationReadAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 27/07/26.
//

import Foundation




class NotificationReadAPICaller {

    static let shared = NotificationReadAPICaller()

    func markNotificationAsRead(
        notificationID: String,
        completion: @escaping (Result<NotificationReadResponse, NetworkError>) -> Void
    ) {

        let urlString = baseURL + APIEndpoint.readNotification.rawValue

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
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let body = "notify_id=\(notificationID)"
        request.httpBody = body.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                print("❌ READ NOTIFICATION ERROR: \(error.localizedDescription)")

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

            print("📌 READ NOTIFICATION STATUS CODE: \(httpResponse.statusCode)")

            if let json = String(data: data, encoding: .utf8) {
                print("📌 READ NOTIFICATION RESPONSE: \(json)")
            }

            switch httpResponse.statusCode {

            case 200...299:

                do {

                    let response = try JSONDecoder().decode(
                        NotificationReadResponse.self,
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



