//
//  PhotoCell.swift
//  Unsplash
//
//  Created by Алексей Попов on 13.09.2024.
//

import UIKit

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

    func downloadImage(with urlString: String) {
            // Сохраняем текущий URL
            currentImageURL = urlString
            
            // Очищаем старое изображение
            self.imageView.image = nil
            
            // Проверяем корректность URL
            guard let url = URL(string: urlString) else { return }
            
            // Асинхронная загрузка изображения
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self, let data = data, let image = UIImage(data: data) else { return }
                
                // Проверяем, не изменилась ли URL картинки
                if self.currentImageURL == urlString {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }.resume()
        }
    }
    

