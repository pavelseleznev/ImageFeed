//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 1/4/25.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Internal Property
    var fullImageURL: URL?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    // MARK: - Private Methods
    /// Private method loads the single image and centers in on screen
    private func setImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(let error):
                print("[setImage]: Request error - \(error.localizedDescription)")
                showSingleImageLoadError()
            }
        }
    }
    
    /// Adjusts image to correct size in the view
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        scrollViewDidZoom(scrollView)
    }
    
    /// Private method for showing error alert when viewing a single image
    private func showSingleImageLoadError() {
        let singleImageLoadError = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Повторить", style: .default) {
            [weak self] _ in
            guard let self else { return }
            setImage()
        }
        
        let noAction = UIAlertAction(title: "Не надо", style: .default) {
            [weak self] _ in
            guard let self else { return }
            dismiss(animated: true)
        }
        
        singleImageLoadError.addAction(yesAction)
        singleImageLoadError.addAction(noAction)
        singleImageLoadError.view.accessibilityIdentifier = AccessibilityIdentifiers.singleImageLoadError
        present(singleImageLoadError, animated: true, completion: nil)
    }
    
    // MARK: - IB Actions
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
}

// MARK: UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    /// Adjusts image to center of the view after zooming
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
}
