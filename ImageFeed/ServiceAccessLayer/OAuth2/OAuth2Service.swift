//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/22/25.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("Failed to execute makeOAuthTokenRequest")
            return
        }
        
        URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let oauthTokenData = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(oauthTokenData.accessToken))
                    
                } catch {
                    print("Failed decoding token response")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Failed loading token response")
                completion(.failure(error))
            }
        }
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.tokenURLString) else {
            print("Failed to create URLComponents from Constants.tokenURLString")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: Constants.authorizationCode)]
        
        guard let url = urlComponents.url else {
            print("Failed to create URL from urlComponents from Constants")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}
