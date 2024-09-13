//
//  PhotoModel.swift
//  Unsplash
//
//  Created by Алексей Попов on 12.09.2024.
//

import Foundation

struct ResultsPhotosModel: Codable {
    let results: [PhotoModel]?
}

struct PhotoModel: Codable {
    let id: String?
    let createdDate: String?
    let width: Int
    let height: Int
    let downloads: Int?
    let likes: Int?
    let user: User?
    let urls: [Urls.RawValue:String]?
    
    var aspectRatio: CGFloat { return CGFloat(height) / CGFloat(width) }
    
    enum Urls: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, downloads, likes, user, urls
        case createdDate = "created_at"
    }
}

struct User: Codable {
    let name: String?
    let location: String?
}
