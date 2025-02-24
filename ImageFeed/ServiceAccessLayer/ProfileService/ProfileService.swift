//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 2/5/25.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private let oauth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage.shared
    private weak var urlSession = URLSession.shared
    private weak var task: URLSessionTask?
    private(set) var profile: Profile?
    private init() {}
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void ) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = fetchProfileURL(authToken: token) else {
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                self.profile = Profile(
                    username: profile.username ?? "",
                    name: "\(profile.firstName ?? "") \(profile.lastName ?? "")",
                    loginName: "@\(profile.username ?? "")",
                    bio: profile.bio ?? ""
                )
                guard let profileData = self.profile else {
                    return
                }
                completion(.success(profileData))
                self.task = nil
            case .failure(let error):
                print("[objectTask]: URLSession error - Failed to load profile data: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func fetchProfileURL(authToken: String) -> URLRequest? {
        let profileURL = URL(string: "me", relativeTo: Constants.defaultBaseURLString)
        
        guard let url = profileURL else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
