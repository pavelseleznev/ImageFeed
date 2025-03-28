//
//  ViewController.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 12/19/24.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    // MARK: - IB Outlet
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Public Property
    var presenter: ImagesListPresenterProtocol?
    
    // MARK: - Private Properties
    private let showSingleImageSegueIdentifier: String = "ShowSingleImage"
    private weak var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImagesListPresenter(view: self)
        presenter?.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath else { return }
            if let url = presenter?.imagesListService.photos[indexPath.row].fullImageURL,
               let imageURL = URL(string: url) {
                viewController.fullImageURL = imageURL
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Public Methods
    func setupLikeAlert() {
        let changeLikeAlert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось поставить/убрать лайк",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        
        changeLikeAlert.addAction(action)
        changeLikeAlert.view.accessibilityIdentifier = AccessibilityIdentifiers.changeLikeAlert
        present(changeLikeAlert, animated: true, completion: nil)
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            var indexPaths: [IndexPath] = []
            for i in oldCount..<newCount {
                indexPaths.append(IndexPath(row: i, section: 0))
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}

// MARK: UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = presenter?.imagesListService.photos[indexPath.row] else {
            return 0
        }
        
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
        guard let loadedPhotos = presenter?.photos[indexPath.row] else { return }
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
        
        if let date = presenter?.photos[indexPath.row].createdAt {
            cell.dateLabel.text = DateFormatter.dateFormatterDefault.string(from: date)
        }
        
        guard let like = presenter?.photos[indexPath.row].isLiked else { return }
        cell.setIsLiked(isLiked: like)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let photosCount = presenter?.imagesListService.photos.count else { return 0 }
        return photosCount
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ProcessInfo.processInfo.arguments.contains("UITests") {
            return
        }
        if indexPath.row + 1 == presenter?.imagesListService.photos.count {
            presenter?.imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.imageListCellDidTapLike(cell, indexPath: indexPath)
    }
}
