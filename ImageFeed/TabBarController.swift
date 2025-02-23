//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 2/16/25.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Tab Editorial Active"),
            selectedImage: nil)
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Tab Profile Active"),
            selectedImage: nil
        )
        
        UITabBar.appearance().barTintColor = AppColor.ypBlack
        UITabBar.appearance().tintColor = AppColor.ypWhite
        
        UINavigationBar.appearance().barTintColor = AppColor.ypBlack
        UINavigationBar.appearance().tintColor = AppColor.ypWhite
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
