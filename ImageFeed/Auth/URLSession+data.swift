//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/24/25.
//

import Foundation

extension URLSession {
    private func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    let handleError = self.showNetworkError(for: statusCode)
                    print("[dataTask]: Network Error - \(handleError)")
                    fulfillCompletionOnTheMainThread(.failure(handleError))
                }
            } else if let error = error {
                print("[dataTask]: Network Error - \(error.localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.internalServerError))
            } else {
                print("[dataTask]: Network Error - \(NetworkError.internalServerError)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.internalServerError))
            }
        })
        return task
    }
    
    private func showNetworkError(for statusCode: Int) -> NetworkError {
        if let httpsCode = HTTPStatusCode(rawValue: statusCode) {
            switch httpsCode {
            case .authorizationRequiredStatus:
                return NetworkError.authorizationRequiredError
            case .webPageNotFoundStatus:
                return NetworkError.webPageNotFoundError
            case .internalServerErrorStatus:
                return NetworkError.internalServerError
            }
        }
        return NetworkError.urlSessionError
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
            
            let task = data(for: request) { (result: Result<Data, Error>) in
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let jsonResponse = try decoder.decode(T.self, from: data)
                        completion(.success(jsonResponse))
                    } catch {
                        print("[objectTask]: Decoding error - \(error.localizedDescription), Data: \(String(data: data, encoding: .utf8) ?? "")")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("[objectTask]: Error - \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            return task
        }
}
