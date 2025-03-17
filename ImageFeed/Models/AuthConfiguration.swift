//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/17/25.
//

import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    
    let defaultBaseURLString: URL
    let authorizeURLString: String
    let tokenURLString: String
    let authorizePath: String
    let authorizationCode: String
    
    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         defaultBaseURLString: URL,
         authorizeURLString: String,
         tokenURLString: String,
         authorizePath: String,
         authorizationCode: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURLString = defaultBaseURLString
        self.authorizeURLString = authorizeURLString
        self.tokenURLString = tokenURLString
        self.authorizePath = authorizePath
        self.authorizationCode = authorizationCode
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            defaultBaseURLString: Constants.defaultBaseURLString,
            authorizeURLString: Constants.authorizeURLString,
            tokenURLString: Constants.tokenURLString,
            authorizePath: Constants.authorizePath,
            authorizationCode: Constants.authorizationCode)
    }
}
