//
//  Photo.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 2/25/25.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let thumbImageURL: String?
    let fullImageURL: String?
    var isLiked: Bool
}
