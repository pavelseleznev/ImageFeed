//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Pavel Seleznev on 3/15/25.
//

@testable import ImageFeed
import XCTest

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var imagesListService = ImagesListService.shared
    var viewDidLoadCalled: Bool = false
    var didUpdateTable: Bool = false
    var photos: [ImageFeed.Photo] = []
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateTableViewAnimated() {
        didUpdateTable = true
    }
    
    func imageListCellDidTapLike(_ cell: ImageFeed.ImagesListCell, indexPath: IndexPath) {}
}
