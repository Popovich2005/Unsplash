//
//  FavoritePhotoCell.swift
//  Unsplash
//
//  Created by Алексей Попов on 13.09.2024.
//

import UIKit
import Alamofire
import AlamofireImage

class FavoritePhotoCell: UITableViewCell {
    
    static let identifier = "FavouritePhotoCell"
    
    var photoModel: DetailsPhotoModel?
    
    let shadowView: UIView = {
        let shadow = UIView()
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.layer.cornerRadius = 8
        shadow.layer.shadowRadius = 4
        shadow.layer.shadowOpacity = 0.8
        shadow.layer.shadowOffset = .zero
        shadow.layer.shadowColor = UIColor.label.cgColor
        return shadow
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.label.cgColor
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        return image
    }()
    
    let authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        authorNameLabel.text = ""
    }
    
    func downloadImage(with url: URL?) {
        guard let url = url else {
            image.image = nil
            return
        }
        image.image = nil
        AF.request(url).responseData { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image.image = image
                    }
                }
            case .failure(let error):
                print("Error loading image: \(error)")
            }
        }
    }
    
    func configure(with model: DetailsPhotoModel) {
        self.photoModel = model
        if let imageURL = photoModel?.smallImage {
            downloadImage(with: imageURL)
        } else {
            image.image = nil
        }
        authorNameLabel.text = model.authorName
    }
    
    private func setupCell() {
        contentView.addSubview(shadowView)
        shadowView.addSubview(image)
        contentView.addSubview(authorNameLabel)
        
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            shadowView.widthAnchor.constraint(equalToConstant: 120),
            shadowView.heightAnchor.constraint(equalToConstant: 120),
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            image.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            image.topAnchor.constraint(equalTo: shadowView.topAnchor),
            image.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            authorNameLabel.leadingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: 16),
            authorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            authorNameLabel.centerYAnchor.constraint(equalTo: shadowView.centerYAnchor)
        ])
    }
    
}
