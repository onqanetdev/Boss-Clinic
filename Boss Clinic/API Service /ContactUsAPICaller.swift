//
//  ContactUsAPICaller.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 15/07/26.
//

import Foundation



final class ContactUsAPICaller {

    static func sendContactMessage(
        name: String,
        email: String,
        message: String,
        completion: @escaping (Result<ContactUsModel, Error>) -> Void
    ) {

        let urlString = baseURL + APIEndpoint.contacts.rawValue

        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.urlError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "name": name,
            "email": email,
            "message": message
        ]

        do {
            request.httpBody = try JSONSerialization.data(
                withJSONObject: body,
                options: []
            )
        } catch {
            completion(.failure(NetworkError.serverError))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.responsErr))
                }
                return
            }

            print("📌 CONTACT STATUS CODE:", httpResponse.statusCode)

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.responsErr))
                }
                return
            }

            if let json = String(data: data, encoding: .utf8) {
                print("📌 CONTACT RESPONSE:", json)
            }

            switch httpResponse.statusCode {

            case 200, 201:

                do {
                    let response = try JSONDecoder().decode(ContactUsModel.self, from: data)

                    DispatchQueue.main.async {
                        completion(.success(response))
                    }

                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.decodingError))
                    }
                }

            case 401:

                DispatchQueue.main.async {
                    completion(.failure(NetworkError.unauthorized))
                }

            case 422:

                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let message = json["message"] as? String {

                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.validationError(message)))
                    }

                } else {

                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.serverError))
                    }
                }

            default:

                DispatchQueue.main.async {
                    completion(.failure(NetworkError.serverError))
                }
            }

        }.resume()
    }
}


