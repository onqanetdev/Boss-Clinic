//
//  NotificationSettingsUpdateAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 17/07/26.
//

import Foundation


class NotificationSettingsUpdateAPICaller {

    static let shared = NotificationSettingsUpdateAPICaller()

    func updateNotificationSettings(
        medicationReminders: Bool,
        refillReminders: Bool,
        sound: Bool,
        vibration: Bool,
        completion: @escaping (Result<NotificationSettingUpdateModel, NetworkError>) -> Void
    ) {

        let urlString = baseURL + APIEndpoint.notificationSettings.rawValue

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

        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "medication_reminders": medicationReminders,
            "refill_reminders": refillReminders,
            "sound": sound,
            "vibration": vibration
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(.serverError))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                print("❌ UPDATE NOTIFICATION SETTINGS ERROR: \(error.localizedDescription)")

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

            print("📌 UPDATE NOTIFICATION SETTINGS STATUS CODE: \(httpResponse.statusCode)")

            if let json = String(data: data, encoding: .utf8) {
                print("📌 UPDATE NOTIFICATION SETTINGS RESPONSE: \(json)")
            }

            switch httpResponse.statusCode {

            case 200...299:

                do {

                    let response = try JSONDecoder().decode(
                        NotificationSettingUpdateModel.self,
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



