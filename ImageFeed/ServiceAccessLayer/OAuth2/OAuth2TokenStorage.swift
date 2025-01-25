//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/24/25.
//

import Foundation

protocol OAuth2TokenStorageProtocol {
    var token: String? { get set }
}

// Provides data persistency for OAuth2Token using userDefaults storage
final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let newValue else {
                assertionFailure("Invalid token")
                return
            }
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
