//
//  ViewController.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 12/19/24.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: - IB Outlet
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Properties
    /// A property containing segue identifier for SingleImageViewController
    private let showSingleImageSegueIdentifier: String = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private weak var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            updateTableViewAnimated()
        }
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath else { return }
            if let url = imagesListService.photos[indexPath.row].fullImageURL,
               let imageURL = URL(string: url) {
                viewController.fullImageURL = imageURL
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Method
    /// Updates the tableView with new photos
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in oldCount..<newCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: UITableViewDelegate
/// Sets the height of the cells depending on the displaying image
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = imagesListService.photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    /// Checks the segue identifier for SingleImageViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

// MARK: UITableViewDataSource
/// Sets the list of cells for displaying images
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.showImagesListCellIdentifier, for: indexPath)
        
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imagesListCell.delegate = self
        
        configCell(for: imagesListCell, with: indexPath)
        return imagesListCell
    }
    
    /// Configures the image cell, e.g. image, date, Like button
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        if let url = imagesListService.photos[indexPath.row].thumbImageURL,
           let imageURL = URL(string: url) {
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "Stub")) { [weak self] _ in
                    guard let self else { return }
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            if let date = imagesListService.photos[indexPath.row].createdAt {
                cell.dateLabel.text = DateFormatter.longDateFormatter.string(from: date)
            }
            let like = imagesListService.photos[indexPath.row].isLiked
            cell.setIsLiked(isLiked: like)
        }
    }
    
    /// Sets the number of photos in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    /// Loads the next page of list of photos
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) {  [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
            case .failure(let error):
                print(error.localizedDescription)
                showChangeLikeError()
            }
        }
    }
    
    private func showChangeLikeError() {
        let changeLikeAlert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось поставить/убрать лайк",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default)
        
        changeLikeAlert.addAction(action)
        changeLikeAlert.view.accessibilityIdentifier = AccessibilityIdentifiers.changeLikeAlert
        present(changeLikeAlert, animated: true, completion: nil)
    }
}
