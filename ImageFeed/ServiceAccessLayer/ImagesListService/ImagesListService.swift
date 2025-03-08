//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 2/25/25.
//

import Foundation

final class ImagesListService {
    private weak var urlSession = URLSession.shared
    private weak var task: URLSessionTask?
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var nextPage: Int?
    private let perPage = 10
    private let oauth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage.shared
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private init() {}
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        task?.cancel()
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = fetchImageURL(page: nextPage, perPage: perPage) else {
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photoResult):
                let downloadedPhotos = photoResult.map { photoResult in
                    Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: DateFormatter.dateFormatterISO.date(from: photoResult.createdAt ?? ""),
                        thumbImageURL: photoResult.urls.thumb,
                        fullImageURL: photoResult.urls.full,
                        isLiked: photoResult.likedByUser)
                }
                
                let newPhotos = downloadedPhotos.filter { newPhoto in
                    !self.photos.contains(where: { $0.id == newPhoto.id })
                }
                
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                self.task = nil
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self
                )
            case .failure(let error):
                print("[objectTask]: URLSession error - Failed to load list of photos: \(error.localizedDescription)")
            }
        }
        self.task = task
        task.resume()
    }
    
    private func fetchImageURL(page: Int, perPage: Int) -> URLRequest? {
        let listPhotosURL = URL(string: "photos?page=\(page)&&per_page=\(perPage)", relativeTo: Constants.defaultBaseURLString)
        
        guard let url = listPhotosURL,
              let token = oauth2TokenStorage.token else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        task?.cancel()
        
        guard let request = fetchLikeUrl(photoId: photoId, isLike: isLike) else { return }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            DispatchQueue.main.async { [ weak self ] in
                guard let self else { return }
                
                switch result {
                case .success:
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            thumbImageURL: photo.thumbImageURL,
                            fullImageURL: photo.fullImageURL,
                            isLiked: !photo.isLiked
                        )
                        self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                    }
                    completion(.success(()))
                    self.task = nil
                case .failure(let error):
                    print("[objectTask]: URLSession error LikeResult - \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    private func fetchLikeUrl(photoId: String, isLike: Bool) -> URLRequest? {
        let photoURL = URL(string: "photos/\(photoId)/like", relativeTo: Constants.defaultBaseURLString)
        
        guard let url = photoURL,
              let token = oauth2TokenStorage.token else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? HTTPMethod.post.rawValue : HTTPMethod.delete.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    func cleanPhotosData() {
        photos.removeAll()
        lastLoadedPage = nil
        task = nil
    }
}

extension Array {
    func withReplaced(itemAt: Int, newValue: Photo) -> [Photo] {
        var photos = ImagesListService.shared.photos
        photos.replaceSubrange(itemAt...itemAt, with: [newValue])
        return photos
    }
}
