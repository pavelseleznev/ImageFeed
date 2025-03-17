//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Pavel Seleznev on 3/16/25.
//

@testable import ImageFeed
import XCTest

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {}
    func setProgressHidden(_ isHidden: Bool) {}
}
