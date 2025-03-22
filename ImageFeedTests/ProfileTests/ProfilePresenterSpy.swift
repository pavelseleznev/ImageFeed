//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Pavel Seleznev on 3/15/25.
//

@testable import ImageFeed
import XCTest

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ImageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func showLogoutConfirmationAlert() -> UIAlertController { UIAlertController() }
}
