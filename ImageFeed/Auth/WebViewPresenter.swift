//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/11/25.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Internal Property
    weak var view: WebViewViewControllerProtocol?
    
    // MARK: - Private Property
    private var authHelper: AuthHelperProtocol
    
    // MARK: - Lifecycle
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else { return }
        
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    // MARK: - Public Methods
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    /// Provides the authorization code if login attempt is successful
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
