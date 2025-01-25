//
//  Constants.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/15/25.
//

import Foundation

/// A primary enum containing basic constants such as access/secret keys, full urls strings and additional url paths
enum Constants {
    static let accessKey: String = "0OU4UDtYPPfRvvtzclbAGBd1DVvEP2wxn0eoKyBIQtE"
    static let secretKey: String = "Sn10mXiGYMvI_6ExCcHFQ44OXa5JafhIWyIWtvLiTOg"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    
    static let defaultBaseURLString = URL(string: "https://api.unsplash.com")
    static let authorizeURLString: String = "https://unsplash.com/oauth/authorize"
    static let tokenURLString: String = "https://unsplash.com/oauth/token"
    static let authorizePath: String = "/oauth/authorize/native"
    static let authorizationCode: String = "authorization_code"
}
