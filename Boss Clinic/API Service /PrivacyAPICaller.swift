//
//  PrivacyAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 15/07/26.
//

import Foundation



final class PrivacyAPICaller {

    static func fetchPrivacyPolicy(
        completion: @escaping (Result<PrivacyModel, NetworkError>) -> Void
    ) {

        let urlString = baseURL + APIEndpoint.privacyPolicy.rawValue

        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("❌ PRIVACY API ERROR:", error.localizedDescription)

                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {

                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
                return
            }

            print("📌 PRIVACY STATUS CODE:", httpResponse.statusCode)

            guard let data = data else {

                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
                return
            }

            if let json = String(data: data, encoding: .utf8) {
                print("📌 PRIVACY RESPONSE:", json)
            }

            guard (200...299).contains(httpResponse.statusCode) else {

                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
                return
            }

            do {

                let response = try JSONDecoder().decode(PrivacyModel.self, from: data)

                DispatchQueue.main.async {
                    completion(.success(response))
                }

            } catch {

                print("❌ DECODING ERROR:", error)

                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }

        }.resume()
    }
}

