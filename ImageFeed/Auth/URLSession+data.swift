//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/24/25.
//

import Foundation

enum NetworkError: Error {
    case authorizationRequiredError
    case webPageNotFoundError
    case internalServerError
    case urlSessionError
}

enum HTTPStatusCode: Int {
    case authorizationRequiredStatus = 401
    case webPageNotFoundStatus = 404
    case internalServerErrorStatus = 500
}

extension URLSession {
    /// Loads the web data on the main queue
    func data( for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void ) {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        Task {
            do {
                let data = try await self.loadNetworkData(request: request)
                fulfillCompletionOnTheMainThread(.success(data))
            } catch {
                print("Failed to loadNetworkData request")
                fulfillCompletionOnTheMainThread(.failure(error))
            }
        }
    }
    
    /// Checks for response code from the server
    func loadNetworkData(request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse,
           response.statusCode < 200 || response.statusCode >= 300
        {
            let statusCode = response.statusCode
            throw showNetworkError(for: statusCode)
        }
        return data
    }
    
    /// Handles server's error responses
    func showNetworkError(for statusCode: Int) -> NetworkError {
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
}
