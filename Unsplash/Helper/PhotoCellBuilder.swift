//
//  PhotoCellBuilder.swift
//  Unsplash
//
//  Created by Алексей Попов on 13.09.2024.
//

import Foundation

final class PhotoCellBuilder {
    
    private func buildDetailsPhoto(from response: PhotoModel) -> DetailsPhotoModel {
        let id = response.id ?? ""
        let aspectRatio = response.aspectRatio
        let downloadsCount = response.downloads ?? 0
        let likesCount = response.likes ?? 0
        let location = response.user?.location ?? "None"
        let authorName = response.user?.name ?? "None"
        
        var createdDate = ""
        let date = response.createdDate ?? ""
        
        if let index = date.range(of: "T")?.lowerBound {
            let temp = date[..<index]
            createdDate = String(temp)
        }
        
        guard let smallUrl = response.urls?["small"], let thumbUrl = response.urls?["thumb"]
                
        else {
            return DetailsPhotoModel(
                id: id,
                aspectRatio: aspectRatio,
                downloadsCount: downloadsCount,
                likesCount: likesCount,
                authorName: authorName,
                location: location,
                smallImage: nil,
                thumbImage: nil,
                createdDate: createdDate
            )
        }
        
        let smallImageUrl = URL(string: smallUrl)
        let thumbImageUrl = URL(string: thumbUrl)
        
        return DetailsPhotoModel(
            id: id,
            aspectRatio: aspectRatio,
            downloadsCount: downloadsCount,
            likesCount: likesCount,
            authorName: authorName,
            location: location,
            smallImage: smallImageUrl,
            thumbImage: thumbImageUrl,
            createdDate: createdDate
        )
    }
    
    func buildCellsModels(from response: [PhotoModel], completion: (([DetailsPhotoModel]) -> Void)) {
        let models = response.compactMap(buildDetailsPhoto)
        completion(models)
    }
}
