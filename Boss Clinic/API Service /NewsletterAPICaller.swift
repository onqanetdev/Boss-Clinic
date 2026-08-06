//
//  NewsletterAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 03/08/26.
//

import Foundation



class NewsletterAPICaller {
    
    static let shared = NewsletterAPICaller()
    
    func fetchNewsletters(
        completion: @escaping (Result<NewsletterResponse, NetworkError>) -> Void
    ) {
        
        // ✅ Internet check
        guard NetworkMonitor.shared.isConnected else {
            DispatchQueue.main.async {
                completion(.failure(.noInternet))
            }
            return
        }
        
        
        let urlString = baseURL + APIEndpoint.newsletters.rawValue
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            SessionManager.shared.logout()
            completion(.failure(.validationError("Access Token not found.")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                
                print("❌ NEWSLETTER ERROR: \(error.localizedDescription)")
                
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
            
            print("📌 NEWSLETTER STATUS CODE: \(httpResponse.statusCode)")
            
            if let json = String(data: data, encoding: .utf8) {
                print("📌 NEWSLETTER RESPONSE: \(json)")
            }
            
            switch httpResponse.statusCode {
                
            case 200...299:
                
                do {
                    
                    let response = try JSONDecoder().decode(
                        NewsletterResponse.self,
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




