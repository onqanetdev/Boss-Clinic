//
//  ConsultNowAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 31/07/26.
//

import Foundation



class ConsultNowAPICaller {
    
    static let shared = ConsultNowAPICaller()
    
    func createAppointment(
        appointmentDate: String,
        appointmentTime: String,
        status: String,
        reason: String,
        completion: @escaping (Result<BookAppointmentResponse, NetworkError>) -> Void
    ) {
        
        // ✅ Internet check
        guard NetworkMonitor.shared.isConnected else {
            DispatchQueue.main.async {
                completion(.failure(.noInternet))
            }
            return
        }
        
        let urlString = baseURL + APIEndpoint.createAppointment.rawValue
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            SessionManager.shared.logout()
            completion(.failure(.validationError("Access Token not found.")))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "appointment_date": appointmentDate,
            "appointment_time": appointmentTime,
            "status": status,
            "reason": reason
        ]
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(.decodingError))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                
                print("❌ CREATE APPOINTMENT ERROR: \(error.localizedDescription)")
                
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
            
            print("📌 CREATE APPOINTMENT STATUS CODE: \(httpResponse.statusCode)")
            
            if let json = String(data: data, encoding: .utf8) {
                print("📌 CREATE APPOINTMENT RESPONSE: \(json)")
            }
            
            switch httpResponse.statusCode {
                
            case 200...299:
                
                do {
                    
                    let response = try JSONDecoder().decode(
                        BookAppointmentResponse.self,
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

