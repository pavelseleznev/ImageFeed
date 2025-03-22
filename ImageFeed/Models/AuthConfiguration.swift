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
