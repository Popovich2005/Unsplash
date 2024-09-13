//
//  CreatePhotos.swift
//  Unsplash
//
//  Created by Алексей Попов on 13.09.2024.
//

import Foundation

final class CreatePhotos {
    private let detailsPhoto: [DetailsPhotoModel] = []
    private let key = "detailsPhoto"
    
    func loadPhoto() -> [DetailsPhotoModel] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return detailsPhoto }
        
        do {
            let photos = try JSONDecoder().decode([DetailsPhotoModel].self, from: data)
            return photos
        } catch {
            return detailsPhoto
        }
    }
    
    func savePhoto(photos: [DetailsPhotoModel]) {
        do {
            let data = try JSONEncoder().encode(photos)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func deletePhoto(photo: DetailsPhotoModel) {
        do {
            let photos = loadPhoto()
            let newPhotos = photos.filter { $0.id != photo.id }
            let data = try JSONEncoder().encode(newPhotos)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            debugPrint(String(describing: error))
        }
    }
}
