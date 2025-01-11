//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/4/25.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    private weak var avatarImageView: UIImageView!
    // Displays user's full name
    private weak var nameLabel: UILabel!
    // Displays user's login
    private weak var loginLabel: UILabel!
    // Displays user's description
    private weak var descriptionLabel: UILabel!
    private weak var logoutButton: UIButton!
    
    // MARK: - IBAction
    @IBAction private func didTapLogoutButton () {}
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addAvatarImageView()
        addNameLabel()
        addLoginLabel()
        addDescriptionLabel()
        addLogoutButton()
    }
    
    // MARK: - Private Methods
    private func addAvatarImageView() {
        let avatarImage = UIImageView(image: UIImage(named: "avatar"))
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImage.layer.cornerRadius = 35
        avatarImage.layer.masksToBounds = true
        view.addSubview(avatarImage)
        
        avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        self.avatarImageView = avatarImage
    }
    
    // Shows user's full name
    private func addNameLabel() {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 23)
        view.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: self.avatarImageView!.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView!.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.nameLabel = nameLabel
    }
    
    // Shows user's login
    private func addLoginLabel() {
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        loginLabel.textColor = UIColor(named: "YP_light_gray_color")
        loginLabel.font = .systemFont(ofSize: 13)
        view.addSubview(loginLabel)
        
        loginLabel.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 8).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: nameLabel!.leadingAnchor).isActive = true
        loginLabel.trailingAnchor.constraint(equalTo: nameLabel!.trailingAnchor).isActive = true
        self.nameLabel = loginLabel
    }
    
    // Shows user's description
    private func addDescriptionLabel() {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel!.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel!.trailingAnchor).isActive = true
    }
    
    private func addLogoutButton() {
        let logoutButton = UIButton()
        logoutButton.setImage(UIImage(named: "logout_button"), for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarImageView!.trailingAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        logoutButton.addTarget(self, action: #selector(Self.didTapLogoutButton), for: UIControl.Event.touchUpInside)
    }
}
