//
//  DetailsPhotoModel.swift
//  Unsplash
//
//  Created by Алексей Попов on 12.09.2024.
//

import Foundation

struct DetailsPhotoModel: Codable {
    let id: String
    let aspectRatio: CGFloat
    let downloadsCount: Int
    var likesCount: Int
    let authorName: String
    let location: String
    let smallImage: URL?
    let thumbImage: URL?
    let createdDate: String
    var isFavourite: Bool = false
}

