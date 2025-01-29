//
//  OAuth2TokenResponseBody.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/26/25.
//

import Foundation

struct OAuth2TokenResponseBody: Decodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
