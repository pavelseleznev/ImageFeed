//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Pavel Seleznev on 3/16/25.
//

@testable import ImageFeed
import XCTest

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    var view: WebViewViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {}
    
    func code(from url: URL) -> String? { return nil }
}
