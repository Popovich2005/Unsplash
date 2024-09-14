//
//  FavoritesSingleton.swift
//  Unsplash
//
//  Created by Алексей Попов on 13.09.2024.
//

import Foundation

final class Favorites {
    
    static let shared = Favorites()
    private let createPhotos = CreatePhotos()
    var favorites: [DetailsPhotoModel] {
        didSet {
            createPhotos.savePhoto(photos: favorites)
        }
    }
    
    private init() {
        favorites = createPhotos.loadPhoto()
    }
    
    func add(photo: DetailsPhotoModel) {
        favorites.append(photo)
    }
    
    func delete(photo: DetailsPhotoModel) {
        createPhotos.deletePhoto(photo: photo)
        favorites = createPhotos.loadPhoto()
    }
}

