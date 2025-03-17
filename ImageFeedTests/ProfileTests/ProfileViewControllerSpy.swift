//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Pavel Seleznev on 3/17/25.
//

@testable import ImageFeed
import XCTest

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var avatarImageView: UIImageView
    
    init(presenter: ImageFeed.ProfilePresenterProtocol? = nil, avatarImageView: UIImageView) {
        self.presenter = presenter
        self.avatarImageView = avatarImageView
    }
    
    func setupAvatarImage(avatarURL: URL) {}
}
