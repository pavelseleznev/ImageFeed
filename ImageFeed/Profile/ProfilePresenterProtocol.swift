//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/17/25.
//

import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
}
