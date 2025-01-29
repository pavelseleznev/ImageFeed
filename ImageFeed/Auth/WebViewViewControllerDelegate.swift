//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/26/25.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
