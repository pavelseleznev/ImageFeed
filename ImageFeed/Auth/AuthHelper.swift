//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/11/25.
//

import Foundation

final class AuthHelper: AuthHelperProtocol {
    private let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else {
            return nil
        }
        
        return URLRequest(url: url)
    }
    
    func authURL() -> URL? {
        guard  var urlComponents = URLComponents(string: configuration.authorizeURLString) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        
        return urlComponents.url
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == Constants.authorizePath,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
