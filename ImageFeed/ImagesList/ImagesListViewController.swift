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
            
            let photo = photos[indexPath.row]
            viewController.fullImageURL = URL(string: photo.fullImageURL)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Method
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

// MARK: UITableViewDataSource
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
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let loadedPhotos = photos[indexPath.row]
        let loadedPhotosURL = URL(string: loadedPhotos.thumbImageURL)
        let loadedPhotosIndexPath = indexPath
        
        DispatchQueue.main.async {
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(
                with: loadedPhotosURL,
                placeholder: UIImage(named: "Stub")) { [ weak self ] _ in
                    guard let self else { return }
                    
                    guard let currentIndexPath = self.tableView.indexPath(for: cell),
                          currentIndexPath == loadedPhotosIndexPath else {
                        cell.cellImage.image = UIImage(named: "Stub")
                        return
                    }
                }
        }
        
        if let date = self.photos[indexPath.row].createdAt {
            cell.dateLabel.text = DateFormatter.dateFormatterDefault.string(from: date)
        }
        
        let like = self.photos[indexPath.row].isLiked
        cell.setIsLiked(isLiked: like)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
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
