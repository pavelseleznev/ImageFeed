//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/17/25.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
