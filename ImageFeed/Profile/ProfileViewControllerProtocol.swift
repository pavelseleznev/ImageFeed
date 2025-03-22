//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/17/25.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    var avatarImageView: UIImageView { get set }
    
    func setupAvatarImage(avatarURL: URL)
}
