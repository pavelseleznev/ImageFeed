//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/17/25.
//

import UIKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func showLogoutConfirmationAlert() -> UIAlertController
}
