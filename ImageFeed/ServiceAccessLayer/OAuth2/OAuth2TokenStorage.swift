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
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private enum Key: String {
        case token
    }
    
    var token: String? {
        get { keyChain.string(forKey: Key.token.rawValue) }
        set {
            guard let newValue else { return }
            keyChain.set(newValue, forKey: Key.token.rawValue)
        }
    }
    
    func cleanTokenStorage() {
        keyChain.removeObject(forKey: Key.token.rawValue)
    }
}
