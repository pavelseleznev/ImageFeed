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
    private var tokenStorage = OAuth2TokenStorage.shared
    private weak var loginButton: UIButton?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.ypBlack
        setupAuthLogo()
        setupLoginButton()
        configureBackButton()
    }
    
    // MARK: - Private Methods
    private func setupAuthLogo() {
        let logo = UIImageView(image: UIImage(named: "Auth Screen Logo"))
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    @objc private func didTapLoginButton() {
        let webViewViewController = WebViewViewController()
        webViewViewController.delegate = self
        webViewViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(webViewViewController, animated: true)
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Nav Back Button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Nav Back Button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = AppColor.ypBlack
    }
    
    private func showAuthErrorAlert() {
        let authErrorAlert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default)
        
        authErrorAlert.addAction(action)
        authErrorAlert.view.accessibilityIdentifier = AccessibilityIdentifiers.authErrorAlert
        present(authErrorAlert, animated: true, completion: nil)
    }
}

// MARK: WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    /// Checks if the OAuth token is loaded/saved and switches to tabBarViewController from login screen
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let token):
                tokenStorage.token = token
                delegate?.didAuthenticate(self)
            case .failure(let error):
                print("[fetchOAuthToken]: Error tokendata - Failed loading fetchOAuthToken: \(error.localizedDescription)")
                showAuthErrorAlert()
            }
            vc.dismiss(animated: true)
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
