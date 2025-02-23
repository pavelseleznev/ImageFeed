//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/18/25.
//

import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    
    // MARK: - Internal Property
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private Properties
    private let showWebViewSegueIdentifier: String = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    private var tokenStorage = OAuth2TokenStorage()
    private weak var loginButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppLogo()
        setupLoginButton()
    }
    
    // MARK: - Private Methods
    private func setupAppLogo() {
        let logo = UIImageView(image: UIImage(named: "Auth Screen Logo"))
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupLoginButton() {
        let loginButton = UIButton()
        loginButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        loginButton.backgroundColor = AppColor.ypWhite
        loginButton.setTitleColor(AppColor.ypBlack, for: .normal)
        loginButton.setTitle("Войти", for: .normal)
        loginButton.layer.cornerRadius = 16
        loginButton.layer.masksToBounds = true
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    @objc private func didTapLoginButton() {
        let webViewViewController = WebViewViewController()
        webViewViewController.delegate = self
        webViewViewController.modalPresentationStyle = .fullScreen
        present(webViewViewController, animated: true)
    }
}

// MARK: WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    // Checks if the OAuth token is loaded/saved and switches to tabBarViewController from login screen
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)

        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let accessToken):
                tokenStorage.token = accessToken
                delegate?.didAuthenticate(self)
            case .failure(let error):
                print("[fetchOAuthToken]: Error tokendata - Failed loading fetchOAuthToken: \(error.localizedDescription)")
                showAuthErrorAlert()
            }
        }
    }
    
    private func showAuthErrorAlert() {
        let authErrorAlert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default)
        
        authErrorAlert.addAction(action)
        authErrorAlert.view.accessibilityIdentifier = "authErrorAlert"
        present(authErrorAlert, animated: true, completion: nil)
        // TODO: Implement resolution:
        // attempt fetchOAuthToken
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
