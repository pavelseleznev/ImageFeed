//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/13/25.
//

import Foundation

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    //MARK: - Public Properties
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    let imagesListService = ImagesListService.shared
    
    // MARK: - Private Property
    private weak var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
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
    
    // MARK: - Public Methods
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath) {
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
                view?.setupLikeAlert()
            }
        }
    }
}
