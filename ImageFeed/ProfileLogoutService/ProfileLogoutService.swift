//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/4/25.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private init() {}
    
    func logout() {
        cleanCookies()
        cleanTokenStorage()
        cleanProfileData()
        cleanProfileImage()
        cleanListPhotosData()
        switchToSplashViewController()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanTokenStorage() {
        OAuth2TokenStorage.shared.cleanTokenStorage()
    }
    
    private func cleanProfileData() {
        ProfileService.shared.cleanProfileData()
    }
    
    private func cleanProfileImage() {
        ProfileImageService.shared.cleanProfileImage()
    }
    
    private func cleanListPhotosData() {
        ImagesListService.shared.cleanPhotosData()
    }
    
    private func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            print("Invalid window configuration")
            return
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
}
