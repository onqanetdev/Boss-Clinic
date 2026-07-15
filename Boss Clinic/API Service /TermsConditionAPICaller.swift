//
//  TermsConditionAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 15/07/26.
//

import Foundation



final class TermsConditionAPICaller {

    static func fetchTermsCondition(
        completion: @escaping (Result<TermsConditionModel, NetworkError>) -> Void
    ) {

        let urlString = baseURL + APIEndpoint.terms.rawValue

        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("❌ TERMS API ERROR:", error.localizedDescription)

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

            print("📌 TERMS STATUS CODE:", httpResponse.statusCode)

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
                return
            }

            if let json = String(data: data, encoding: .utf8) {
                print("📌 TERMS RESPONSE:", json)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
                return
            }

            do {

                let response = try JSONDecoder().decode(TermsConditionModel.self, from: data)

                DispatchQueue.main.async {
                    completion(.success(response))
                }

            } catch {

                print("❌ TERMS DECODING ERROR:", error)

                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }

        }.resume()
    }
}

