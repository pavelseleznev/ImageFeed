//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/17/25.
//

import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
