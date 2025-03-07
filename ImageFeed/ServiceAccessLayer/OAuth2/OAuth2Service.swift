//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/22/25.
//

import Foundation

final class OAuth2Service {
    private var urlSession = URLSession.shared
    private weak var task: URLSessionTask?
    private var lastCode: String?
    static let shared = OAuth2Service()
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            print("[fetchOAuthToken]: Error tokenData - \(AuthServiceError.invalidRequest)")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[makeOAuthTokenRequest]: Request error - \(AuthServiceError.invalidRequest)")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuth2TokenResponseBody, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    completion(.success(token.accessToken))
                    self?.task = nil
                    self?.lastCode = nil
                case .failure(let error):
                    print("[objectTask]: URLSession error tokenData - \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
        
        func makeOAuthTokenRequest(code: String) -> URLRequest? {
            guard var urlComponents = URLComponents(string: Constants.tokenURLString) else {
                print("[makeOAuthTokenRequest]: URLComponents error - Failed to create URL")
                return nil
            }
            
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: Constants.accessKey),
                URLQueryItem(name: "client_secret", value: Constants.secretKey),
                URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "grant_type", value: Constants.authorizationCode)]
            
            guard let url = urlComponents.url else {
                print("[makeOAuthTokenRequest]: URLComponents error - Failed to create URL from urlComponents from Constants")
                return nil
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            
            return request
        }
    }
}
