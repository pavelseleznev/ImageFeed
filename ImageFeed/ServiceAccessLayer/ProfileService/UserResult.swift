//
//  UserResult.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 2/12/25.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ImageResult
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
