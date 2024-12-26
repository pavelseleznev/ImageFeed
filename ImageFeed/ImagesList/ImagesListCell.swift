//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 12/21/24.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - IB Outlets
    /// Image container for photos in ImagesListViewController
    @IBOutlet weak var cellImage: UIImageView!
    /// Heart e.g. Like button in ImagesListViewController
    @IBOutlet weak var likeButton: UIButton!
    /// Label showing the current date
    @IBOutlet weak var dateLabel: UILabel!
    /// Outlet for applying blur effect for date label
    @IBOutlet weak var dateLabelBackground: UILabel!
    
    // MARK: - Internal Property
    /// Cell identifier for ImagesListViewController tableView cells
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Lifecycle
    /// Override method for applying blur effect layers in ImagesListViewController
    override func awakeFromNib() {
        super.awakeFromNib()
        setDateLabelBackground()
    }
    
    // MARK: - Private Method
    /// Method for applying blur effect layers in ImagesListViewController for date label. Uses UIBlurEffect/UIVisualEffectView.
    /// Sets the visual properties of the blur layer
    private func setDateLabelBackground() {
        let blurEffect = UIBlurEffect(style: .light)
        let dateBackgroundBlur = UIVisualEffectView(effect: blurEffect)
        dateBackgroundBlur.alpha = 0.1
        dateBackgroundBlur.layer.cornerRadius = 6
        dateBackgroundBlur.layer.masksToBounds = true
        dateLabelBackground.insertSubview(dateBackgroundBlur, at: 0)
        dateBackgroundBlur.frame = dateLabelBackground.bounds.insetBy(dx: -4, dy: -1)
    }
}
