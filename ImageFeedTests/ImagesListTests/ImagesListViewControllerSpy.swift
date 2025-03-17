//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Pavel Seleznev on 3/17/25.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewControllerSpy: UIViewController, ImagesListViewControllerProtocol {
    
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    var returnAlertCalled = false
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {}
    
    func setupLikeAlert() {
        returnAlertCalled = true
    }
}
