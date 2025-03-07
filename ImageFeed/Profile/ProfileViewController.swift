//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/4/25.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    /// Displays user's avatar photo on the profile screen view
    private weak var avatarImageView: UIImageView?
    /// Displays user's full name on the profile screen view
    private weak var nameLabel: UILabel?
    /// Displays user's login on the profile screen view
    private weak var loginLabel: UILabel?
    /// Displays user's description on the profile screen view
    private weak var descriptionLabel: UILabel?
    /// Outlet for logout button on the profile screen view
    private weak var logoutButton: UIButton?
    /// Checks if user's profile is loaded and updates the avatar view
    private weak var profileImageServiceObserver: NSObjectProtocol?
    /// Profile service responsible for loading and accessing profile data
    private var profileService = ProfileService.shared
    /// Profile logout service responsible for log in out the user, deleting token, web cookies, cached photos and profile data
    private var profileLogoutService = ProfileLogoutService.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.ypBlack
        
        updateAvatar()
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                updateAvatar()
            }
        
        guard let profile = profileService.profile else { return }
        updateProfileDetails(profile: profile)
    }
    
    // MARK: - Private Methods
    /// Shows user's full name on the profile screen view
    private func setupNameLabel(_ name: String) {
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.textColor = AppColor.ypWhite
        nameLabel.font = .boldSystemFont(ofSize: 23)
        view.addSubview(nameLabel)
        
        guard let avatarImageView = avatarImageView else {
            return
        }
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        self.nameLabel = nameLabel
    }
    
    /// Shows user's login on the profile screen view
    private func setupLoginLabel(_ login: String) {
        let loginLabel = UILabel()
        loginLabel.text = login
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        loginLabel.textColor = AppColor.ypGray
        loginLabel.font = .systemFont(ofSize: 13)
        view.addSubview(loginLabel)
        
        guard let nameLabel = nameLabel else {
            return
        }
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
        
        self.nameLabel = loginLabel
    }
    
    /// Shows user's description on the profile screen view
    private func setupDescriptionLabel(_ bio: String) {
        let descriptionLabel = UILabel()
        descriptionLabel.text = bio
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.textColor = AppColor.ypWhite
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        
        guard let nameLabel = nameLabel else {
            return
        }
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    /// Adds logout button to the profile screen view
    private func setupLogoutButton() {
        let logoutButton = UIButton()
        logoutButton.setImage(UIImage(named: "Logout Button"), for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        guard let avatarImageView = avatarImageView else {
            return
        }
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarImageView.trailingAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        logoutButton.addTarget(self, action: #selector(Self.didTapLogoutButton), for: UIControl.Event.touchUpInside)
    }
    
    /// Adds user's avatar image on the profile screen view
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let avatarImage = UIImageView()
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Userpick Stub"),
            options: [.processor(processor)]
        )
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.layer.masksToBounds = true
        view.addSubview(avatarImage)
        
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70)
        ])
        avatarImageView = avatarImage
    }
    
    private func showLogoutConfirmationAlert() {
        let logoutConfirmationAlert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) {
            [weak self] _ in
            guard let self else { return }
            profileLogoutService.logout()
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .default) {
            [weak self] _ in
            guard let self else { return }
            dismiss(animated: true)
        }
        
        logoutConfirmationAlert.addAction(yesAction)
        logoutConfirmationAlert.addAction(noAction)
        logoutConfirmationAlert.view.accessibilityIdentifier = AccessibilityIdentifiers.logoutAlert
        present(logoutConfirmationAlert, animated: true, completion: nil)
    }
    
    // MARK: - IBAction
    @IBAction private func didTapLogoutButton () {
        showLogoutConfirmationAlert()
    }
}

extension ProfileViewController {
    private func updateProfileDetails(profile: Profile) {
        setupNameLabel(profile.name)
        setupLoginLabel(profile.loginName)
        setupDescriptionLabel(profile.bio)
        setupLogoutButton()
    }
}
