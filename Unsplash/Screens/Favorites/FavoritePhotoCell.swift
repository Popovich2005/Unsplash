//
//  FavoritePhotoCell.swift
//  Unsplash
//
//  Created by Алексей Попов on 13.09.2024.
//

import UIKit

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
        image.image = UIImage(named: "hollow knight3")
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.label.cgColor
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        return image
    }()
    
    let authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.text = "FirstName SecondName"
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
    
    func downloadImage(with url: URL?) {
        guard let url = url else {
            image.image = nil // Если URL отсутствует, очищаем изображение
            return
        }
        
        // Сбросим текущее изображение, чтобы избежать отображения старого
        image.image = nil
        
        // Загрузка изображения
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else {
                return
            }
            
            // Обновление пользовательского интерфейса должно происходить в главном потоке
            DispatchQueue.main.async {
                self.image.image = image
            }
        }.resume() // Запускаем задачу
    }
    
    func configure(with model: DetailsPhotoModel) {
        self.photoModel = model

        // Загружаем изображение без использования фреймворка
        if let imageURL = photoModel?.smallImage {
            downloadImage(with: imageURL)
        } else {
            image.image = nil
        }
        authorNameLabel.text = model.authorName
    }
}
