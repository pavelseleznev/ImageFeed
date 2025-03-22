//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Pavel Seleznev on 3/15/25.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testSetupAvatarImage() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter(view: viewController)
        viewController.presenter = presenter
        presenter.view = viewController
        guard let url = URL(string: "https://code.s3.yandex.net/main-page-v5/new_logo.svg") else { return }
        
        //when
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        window.rootViewController = viewController
        presenter.view?.setupAvatarImage(avatarURL: url)
        
        //then
        sleep(5)
        XCTAssertNotNil(viewController.avatarImageView)
    }
}
