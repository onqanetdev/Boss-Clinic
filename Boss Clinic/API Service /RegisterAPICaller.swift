//
//  RegisterAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 13/07/26.
//

import Foundation


class RegisterAPICaller {

    static let shared = RegisterAPICaller()

    func registerUser(
        name: String,
        email: String,
        phone: String,
        password: String,
        confirmPassword: String,
        completion: @escaping (Result<RegisterResponse, NetworkError>) -> Void
    ) {

        let urlString = baseURL + APIEndpoint.register.rawValue

        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "name": name,
            "email": email,
            "phone": phone,
            "password": password,
            "password_confirmation": confirmPassword
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in

            if error != nil {
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

            if let json = String(data: data, encoding: .utf8) {
                print("📌 RAW RESPONSE: \(json)")
            }

            if (200...299).contains(httpResponse.statusCode) {

                do {
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)

                    DispatchQueue.main.async {
                        completion(.success(response))
                    }

                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                }

            } else if let errorResponse = try? JSONDecoder().decode(RegisterErrorModel.self, from: data),
                      let firstMessage = errorResponse.message?.first {

                DispatchQueue.main.async {
                    completion(.failure(.validationError(firstMessage)))
                }

            } else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
            }

        }.resume()
    }
}



