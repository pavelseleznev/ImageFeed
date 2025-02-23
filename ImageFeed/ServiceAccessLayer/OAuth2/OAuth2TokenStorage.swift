//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/24/25.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    private let keyChain = KeychainWrapper.standard
    
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get { keyChain.string(forKey: Keys.token.rawValue) }
        set {
            guard let newValue else { return }
            keyChain.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
