//
//  LogoutAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 22/07/26.
//

import Foundation




class LogoutAPICaller {
 
    static let shared = LogoutAPICaller()
 
    func logout(
        completion: @escaping (Result<LogoutResponse, NetworkError>) -> Void
    ) {
 
        let urlString = baseURL + APIEndpoint.logout.rawValue
        // APIEndpoint.logout = "/logout"
 
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
 
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            // Nothing to log out of on the server — just clear local state.
            SessionManager.shared.logout()
            completion(.failure(.validationError("Access Token not found.")))
            return
        }
 
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
 
        URLSession.shared.dataTask(with: request) { data, response, error in
 
            if let error = error {
 
                print("❌ LOGOUT ERROR: \(error.localizedDescription)")
 
                // Network failed entirely — still clear local state so the
                // user isn't stuck looking logged in with a dead token.
                SessionManager.shared.logout()
 
                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
                return
            }
 
            guard let httpResponse = response as? HTTPURLResponse,
                  let data = data else {
 
                SessionManager.shared.logout()
 
                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
                return
            }
 
            print("📌 LOGOUT STATUS CODE: \(httpResponse.statusCode)")
 
            if let json = String(data: data, encoding: .utf8) {
                print("📌 LOGOUT RESPONSE: \(json)")
            }
 
            switch httpResponse.statusCode {
 
            case 200...299:
 
                do {
 
                    let response = try JSONDecoder().decode(LogoutResponse.self, from: data)
 
                    // Server confirmed the session is closed — clear local
                    // token/state. RootView will switch to LoginScreen.
                    SessionManager.shared.logout()
 
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
 
                } catch {
 
                    print("❌ DECODING ERROR: \(error.localizedDescription)")
 
                    // Even if decoding fails, the request succeeded — still
                    // log the user out locally rather than leaving them stuck.
                    SessionManager.shared.logout()
 
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                }
 
            case 401:
 
                // Token was already invalid/expired — treat as already logged out.
                SessionManager.shared.logout()
 
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



