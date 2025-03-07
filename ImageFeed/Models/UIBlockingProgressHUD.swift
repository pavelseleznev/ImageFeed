//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 2/5/25.
//

import UIKit
import ProgressHUD

///Loading indicator for network tasks (e.g. fetchOAuthToken/fetchProfile)
final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
