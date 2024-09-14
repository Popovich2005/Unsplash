//
//  PhotoDetailsVC.swift
//  Unsplash
//
//  Created by Алексей Попов on 13.09.2024.
//

import UIKit

final class PhotoDetailsVC: UIViewController {
    
    var photoModel: DetailsPhotoModel
    var isfavorite = false
    
    lazy var scrollView: UIScrollView = setupScrollView()
    lazy var authorNameLabel: UILabel = setupAuthorNameLabel()
    lazy var shadowView: UIView = setupShadowView()
    lazy var imageView: UIImageView = setupImageView()
    lazy var dateLabel: UILabel = setupDateLabel()
    lazy var locationLabel: UILabel = setupLocationLabel()
    lazy var downloadsLabel: UILabel = setupDownloadsLabel()
    lazy var likeButton: UIButton = setupButton()
    
    init(photoModel: DetailsPhotoModel) {
        self.photoModel = photoModel
        self.isfavorite = photoModel.isFavourite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupBackButton()
        setupLikeButton()
        setupViews()
        configure()
        
        
    }
    
    @objc private func back() {
        dismiss(animated: true)
    }
    
    @objc func likeTap(_ sender: UIButton) {
        isfavorite.toggle()
        photoModel.isFavourite = isfavorite
        UIButton.transition(with: likeButton,
                            duration: 0.5,
                            options: [.transitionFlipFromLeft],
                            animations: {
            self.photoModel.likesCount += self.isfavorite ? 1 : -1
            self.setupLikeButton()
        })
        isfavorite ? Favorites.shared.add(photo: photoModel) : Favorites.shared.delete(photo: photoModel)
        
        showFavoriteStatusAlert()
        
    }
    
    private func setupBackButton() {
        let backImage = UIImage(systemName: "chevron.left")
        let button = UIBarButtonItem(image: backImage, style: .done, target: self,
                                     action: #selector(back))
        button.tintColor = .label
        navigationItem.setLeftBarButton(button, animated: true)
    }
    
    private func setupLikeButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "hand.thumbsup")
        configuration.title = "\(photoModel.likesCount)"
        configuration.imagePadding = 4
        configuration.baseForegroundColor = isfavorite ? UIColor.white : UIColor.systemTeal
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        
        likeButton.configuration = configuration
        likeButton.backgroundColor = isfavorite ? UIColor.systemPink : UIColor.clear
        likeButton.clipsToBounds = true
        likeButton.layer.cornerRadius = 8
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(likeTap))
        likeButton.addGestureRecognizer(gesture)
        
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(authorNameLabel)
        scrollView.addSubview(shadowView)
        shadowView.addSubview(imageView)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(downloadsLabel)
        scrollView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
               scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               scrollView.topAnchor.constraint(equalTo: view.topAnchor),
               scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               
               authorNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
               authorNameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
               authorNameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
               authorNameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
               
               shadowView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
               shadowView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
               shadowView.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 16),
               shadowView.heightAnchor.constraint(equalTo: shadowView.widthAnchor, multiplier: photoModel.aspectRatio),
               
               imageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
               imageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
               imageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
               imageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
               
               dateLabel.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
               dateLabel.trailingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor),
               dateLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
               dateLabel.topAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: 16),
               
               locationLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
               locationLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
               locationLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
               locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
               
               downloadsLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
               downloadsLabel.trailingAnchor.constraint(equalTo: locationLabel.trailingAnchor),
               downloadsLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
               downloadsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
               
               likeButton.widthAnchor.constraint(equalToConstant: 100),
               likeButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
               likeButton.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor, constant: 16),
               likeButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16) // Добавляем отступ от нижнего края scrollView
           ])
    }
    
    private func downloadImage(with url: URL?) {
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
    
    private func configure() {
        authorNameLabel.text = "Автор: \(photoModel.authorName )"
        
        if let imageURL = photoModel.smallImage {
            downloadImage(with: imageURL)
        } else {
            imageView.image = nil
        }
        
        dateLabel.text = "Дата создания: \(photoModel.createdDate )"
        locationLabel.text = "Город: \(photoModel.location )"
        
        if photoModel.downloadsCount != 0 {
            downloadsLabel.text = "Загрузок: \(photoModel.downloadsCount)"
            downloadsLabel.isHidden = false
        } else {
            downloadsLabel.isHidden = true
        }
    }
    
    private func showFavoriteStatusAlert() {
        let message = isfavorite ? "Фото добавлено в избранное" : "Фото удалено из избранного"
        let title = isfavorite ? "Успех" : "Печаль"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
