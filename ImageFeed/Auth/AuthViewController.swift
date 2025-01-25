//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/18/25.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Internal Properties
    private let showWebViewSegueIdentifier: String = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    // Checks token if the OAuth loaded/saved and switches to tabBarViewController from login screen 
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let accessToken):
                let tokenStorage = OAuth2TokenStorage()
                tokenStorage.token = accessToken
                delegate?.didAuthenticate(self)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
