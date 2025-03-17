//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/4/25.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    //MARK: - Public Properties
    var presenter: ProfilePresenterProtocol?
    var avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
    
    // MARK: - Private Properties
    private weak var nameLabel: UILabel?
    private weak var loginLabel: UILabel?
    private weak var descriptionLabel: UILabel?
    private weak var logoutButton: UIButton?
    private var profileService = ProfileService.shared
    private var profileLogoutService = ProfileLogoutService.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.ypBlack
        presenter = ProfilePresenter(view: self)
        presenter?.viewDidLoad()
        
        guard let profile = profileService.profile else { return }
        updateProfileDetails(profile: profile)
    }
    
    // MARK: - Public Method
    func setupAvatarImage(avatarURL: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarImageView.kf.setImage(
            with: avatarURL,
            placeholder: UIImage(named: "Userpick Stub"),
            options: [.processor(processor)]
        )
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.masksToBounds = true
        view.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    // MARK: - Private Methods
    private func updateProfileDetails(profile: Profile) {
        setupNameLabel(profile.name)
        setupLoginLabel(profile.loginName)
        setupDescriptionLabel(profile.bio)
        setupLogoutButton()
    }
    
    private func setupNameLabel(_ name: String) {
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.textColor = AppColor.ypWhite
        nameLabel.font = .boldSystemFont(ofSize: 23)
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        self.nameLabel = nameLabel
    }
    
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
    
    private func setupLogoutButton() {
        let logoutButton = UIButton()
        logoutButton.setImage(UIImage(named: "Logout Button"), for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarImageView.trailingAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        logoutButton.accessibilityIdentifier = AccessibilityIdentifier.logoutButton.rawValue
        logoutButton.addTarget(self, action: #selector(Self.didTapLogoutButton), for: UIControl.Event.touchUpInside)
    }
    
    private func setupAlert() {
        guard let logoutAlert = self.presenter?.showLogoutConfirmationAlert() else { return }
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
        
        logoutAlert.addAction(yesAction)
        logoutAlert.addAction(noAction)
        logoutAlert.view.accessibilityIdentifier = AccessibilityIdentifiers.logoutAlert
        present(logoutAlert, animated: true, completion: nil)
    }
    
    // MARK: - IBAction
    @IBAction private func didTapLogoutButton() {
        setupAlert()
    }
}
