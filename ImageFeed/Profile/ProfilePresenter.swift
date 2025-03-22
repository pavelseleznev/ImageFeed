//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/13/25.
//

import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    
    //MARK: - Public Property
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Private Property
    private weak var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.loadAvatarImage()
            }
        loadAvatarImage()
    }
    
    // MARK: - Private Method
    private func loadAvatarImage() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.setupAvatarImage(avatarURL: url)
    }
}
