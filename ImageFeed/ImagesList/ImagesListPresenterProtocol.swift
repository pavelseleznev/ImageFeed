//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/17/25.
//

import UIKit

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var imagesListService: ImagesListService { get }
    var photos: [Photo] { get set }
    
    func viewDidLoad()
    func updateTableViewAnimated()
    func imageListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath)
}
