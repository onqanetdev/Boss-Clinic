//
//  RequestRefillAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 21/07/26.
//

import Foundation



class RefillRequestAPICaller {
 
    static let shared = RefillRequestAPICaller()
 
    func requestRefill(
        medicationID: String,
        schedule: String,
        completion: @escaping (Result<RefillRequestResponse, NetworkError>) -> Void
    ) {
 
        let urlString = baseURL + APIEndpoint.refillRequest.rawValue
 
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
 
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            // No token at all — clear any stale state and kick back to login.
            SessionManager.shared.logout()
            completion(.failure(.validationError("Access Token not found.")))
            return
        }
 
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
 
        let body: [String: Any] = [
            "medication_id": medicationID,
            "schedule": schedule
        ]
 
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
 
        URLSession.shared.dataTask(with: request) { data, response, error in
 
            if let error = error {
 
                print("❌ REFILL REQUEST ERROR: \(error.localizedDescription)")
 
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
 
            print("📌 REFILL STATUS CODE: \(httpResponse.statusCode)")
 
            if let json = String(data: data, encoding: .utf8) {
                print("📌 REFILL RESPONSE: \(json)")
            }
 
            switch httpResponse.statusCode {
 
            case 200...299:
 
                do {
 
                    let response = try JSONDecoder().decode(
                        RefillRequestResponse.self,
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
 
                if let errorResponse = try? JSONDecoder().decode(RegisterErrorModel.self, from: data),
                   let firstMessage = errorResponse.message?.first {
 
                    DispatchQueue.main.async {
                        completion(.failure(.validationError(firstMessage)))
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


