//
//  PhotoCell.swift
//  Unsplash
//
//  Created by Алексей Попов on 13.09.2024.
//

import UIKit
import Alamofire
import AlamofireImage

final class PhotoCell: UICollectionViewCell {
    
    static let identifier = "PhotoCell"
    
    private let imageView: UIImageView = UIImageView()
    
    private var currentImageURL: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func downloadImage(with urlString: String) {
        currentImageURL = urlString
        self.imageView.image = nil
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url).responseImage { [weak self] response in
            guard let self = self else { return }
            
            if self.currentImageURL == urlString {
                if let image = response.value {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
    }
    
    private func setupCell() {
        contentView.addSubview(imageView)
        
        let padding: CGFloat = 2
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}
    
