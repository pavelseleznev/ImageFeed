//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 2/12/25.
//

import Foundation

final class ProfileImageService {
    private weak var urlSession = URLSession.shared
    private weak var task: URLSessionTask?
    private(set) var avatarURL: String?
    private init() {}
    private let oauth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage.shared
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private func fetchProfileURL(username: String) -> URLRequest? {
        let profileImageURL = URL(string: "users/\(username)", relativeTo: Constants.defaultBaseURLString)
        
        guard let url = profileImageURL else {
            return nil
        }
        
        NotificationCenter.default
            .post(name: ProfileImageService.didChangeNotification,
                  object: self,
                  userInfo: ["URL": url])
        
        guard let authToken = oauth2TokenStorage.token else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = fetchProfileURL(username: username) else {
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let userResult):
                self.avatarURL = userResult.profileImage.small
                guard let avatarURL = self.avatarURL else {
                    return
                }
                completion(.success(avatarURL))
                
            case .failure(let error):
                print("[objectTask]: URLSession error - Failed decoding avatarURL: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
