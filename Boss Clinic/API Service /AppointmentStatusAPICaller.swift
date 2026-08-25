//
//  AppointmentStatusAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 24/08/26.
//

import Foundation



enum AppointmentActionType: String {
    case cancel
    case confirm
    case reschedule
    case call
}

class AppointmentStatusAPICaller {

    static let shared = AppointmentStatusAPICaller()

    func updateAppointmentStatus(
        appointmentId: String,
        type: AppointmentActionType,
        notes: String? = nil,
        newAppointmentDate: String? = nil,
        newAppointmentTime: String? = nil,
        completion: @escaping (Result<AppointmentStatusUpdateResponse, NetworkError>) -> Void
    ) {

        // ✅ Internet check
        guard NetworkMonitor.shared.isConnected else {
            DispatchQueue.main.async {
                completion(.failure(.noInternet))
            }
            return
        }

        let urlString = baseURL + APIEndpoint.appointmentStatus.rawValue

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

        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var body: [String: Any] = [
            "appointment_id": appointmentId,
            "type": type.rawValue
        ]

        if let notes, !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            body["notes"] = notes
        }

        // Confirmed against a working Postman call — optional, only sent
        // when provided (e.g. reschedule may or may not include a new
        // date/time depending on what the user picked).
        if let newAppointmentDate {
            body["appointment_date"] = newAppointmentDate
        }

        if let newAppointmentTime {
            body["appointment_time"] = newAppointmentTime
        }

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(.serverError))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                print("❌ APPOINTMENT STATUS UPDATE ERROR: \(error.localizedDescription)")

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

            print("📌 APPOINTMENT STATUS UPDATE STATUS CODE: \(httpResponse.statusCode)")

            if let json = String(data: data, encoding: .utf8) {
                print("📌 APPOINTMENT STATUS UPDATE RESPONSE: \(json)")
            }

            switch httpResponse.statusCode {

            case 200...299:

                do {

                    let response = try JSONDecoder().decode(
                        AppointmentStatusUpdateResponse.self,
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
                    completion(.failure(.unauthorized))
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
