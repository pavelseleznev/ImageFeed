//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/17/25.
//

import Foundation

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
