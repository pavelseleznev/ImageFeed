//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/26/25.
//

import Foundation

enum NetworkError: Error {
    case authorizationRequiredError
    case webPageNotFoundError
    case internalServerError
    case urlSessionError
}
