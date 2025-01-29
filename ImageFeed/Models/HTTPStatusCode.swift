//
//  HTTPStatusCode.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/26/25.
//

import Foundation

enum HTTPStatusCode: Int {
    case authorizationRequiredStatus = 401
    case webPageNotFoundStatus = 404
    case internalServerErrorStatus = 500
}
