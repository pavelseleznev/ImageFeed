//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/24/25.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Private Properties
    private let oauth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = AppColor.ypBlack
        setupSplashLogo()
        
        guard let accessToken = oauth2TokenStorage.token else {
            setupAuthScreen()
            return
        }
        
        fetchProfile(accessToken)
    }
    
    // MARK: - Private Methods
    private func setupSplashLogo() {
        let logo = UIImageView(image: UIImage(named: "Splash Screen Logo"))
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupAuthScreen() {
        let authViewController = AuthViewController()
        let navController = UINavigationController(rootViewController: authViewController)
        
        navController.modalPresentationStyle = .fullScreen
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    /// Private method for showing main app screen - a list of photos
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            print("Invalid window configuration")
            return
        }
        
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(_ token: String) {
        
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token: token) { [weak self ] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let profileData):
                ProfileImageService.shared.fetchProfileImageURL(username: profileData.username) { _ in }
                switchToTabBarController()
            case .failure(let error):
                print("[fetchOAuthToken]: Error profileData - \(error.localizedDescription)")
                showLoginErrorAlert()
            }
        }
    }
    
    private func showLoginErrorAlert() {
        let authErrorAlert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default)
        
        authErrorAlert.addAction(action)
        authErrorAlert.view.accessibilityIdentifier = AuthErrorAlert.accessibilityAlertIdentifier
        present(authErrorAlert, animated: true, completion: nil)
        //TODO: Implement resolution:
        //a) dismiss the view;
        //b) attempt fetchProfile
    }
}

// MARK: AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    /// After successful authentication dismisses the current view and switches to TabBarViewController
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let accessToken = oauth2TokenStorage.token else {
            return }
        fetchProfile(accessToken)
    }
}
