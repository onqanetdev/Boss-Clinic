//
//  LoginAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 14/07/26.
//

import Foundation



class LoginAPICaller {
 
    static let shared = LoginAPICaller()
 
    func loginUser(
        phone: String,
        completion: @escaping (Result<OTPResponse, NetworkError>) -> Void) {
 
        let urlString = baseURL + APIEndpoint.login.rawValue
 
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
 
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
 
        let body: [String: Any] = [
            "phone": phone
        ]
 
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
 
        URLSession.shared.dataTask(with: request) { data, response, error in
 
            if let error = error {
                print("❌ LOGIN ERROR: \(error.localizedDescription)")
 
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
 
            print("📌 LOGIN STATUS CODE: \(httpResponse.statusCode)")
 
            if let json = String(data: data, encoding: .utf8) {
                print("📌 LOGIN RESPONSE: \(json)")
            }
 
            if (200...299).contains(httpResponse.statusCode) {
 
                do {
 
                    let response = try JSONDecoder().decode(OTPResponse.self, from: data)
 
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
 
                } catch {
 
                    print("❌ DECODING ERROR: \(error.localizedDescription)")
 
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                }
 
            } else if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
 
                let message = errorResponse.message
                    ?? errorResponse.errors?.phone?.first
                    ?? "Something went wrong."
 
                DispatchQueue.main.async {
                    completion(.failure(.validationError(message)))
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
 


