//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/7/25.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
