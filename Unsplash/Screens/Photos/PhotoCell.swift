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
//            imageView.image = UIImage(named: "hollow knight3")
            imageView.layer.borderWidth = 1
//            imageView.layer.borderColor = UIColor.label.cgColor
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
    
    func downloadImage(with url: URL?) {
        guard let url = url else {
            imageView.image = nil // Если URL отсутствует, очищаем изображение
            return
        }
        
        // Сбросим текущее изображение, чтобы избежать отображения старого
        imageView.image = nil
        
        // Загрузка изображения
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else {
                return
            }
            
            // Обновление пользовательского интерфейса должно происходить в главном потоке
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume() // Запускаем задачу
    }
}
