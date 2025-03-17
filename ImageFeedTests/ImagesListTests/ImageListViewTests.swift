//
//  ImageListViewTests.swift
//  ImageFeedTests
//
//  Created by Pavel Seleznev on 3/15/25.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        _ = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testUpdateTableViewAnimated() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.updateTableViewAnimated()
        
        // then
        XCTAssertTrue(presenter.didUpdateTable)
    }
    
    func testShowChangeLikeError() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        viewController.setupLikeAlert()
        
        // then
        XCTAssertTrue(viewController.returnAlertCalled)
    }
}
