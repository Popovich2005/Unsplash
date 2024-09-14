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
    
    lazy var scrollView: UIScrollView = makeScrollView()
    lazy var authorNameLabel: UILabel = makeAuthorNameLabel()
    lazy var shadowView: UIView = makeShadowView()
    lazy var imageView: UIImageView = makeImageView()
    lazy var dateLabel: UILabel = makeDateLabel()
    lazy var locationLabel: UILabel = makeLocationLabel()
    lazy var downloadsLabel: UILabel = makeDownloadsLabel()
    lazy var likeButton: UIButton = makeLikeButton()
//    lazy var infoLabel: UILabel = makeInfoLabel()
//    lazy var labelDate: UILabel = labelDateText()
    
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
//        setupSaveGesture()
        
        
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
        configuration.image = UIImage(systemName: "hand.thumbsup") // Используем палец вверх
        configuration.title = "\(photoModel.likesCount)"
        configuration.imagePadding = 4
        configuration.baseForegroundColor = isfavorite ? UIColor.white : UIColor.systemTeal
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)

        likeButton.configuration = configuration
        likeButton.backgroundColor = isfavorite ? UIColor.systemPink : UIColor.clear
        likeButton.clipsToBounds = true
        likeButton.layer.cornerRadius = 8

        // Установка фиксированного размера для кнопки
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(likeTap))
        likeButton.addGestureRecognizer(gesture)

        // Добавление действия для нажатия на кнопку
//        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
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
//        scrollView.addSubview(infoLabel)
//        scrollView.addSubview(labelDate)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            authorNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 4),
            authorNameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -4),
            authorNameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            authorNameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            
            shadowView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            shadowView.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 16),
            shadowView.widthAnchor.constraint(equalToConstant: 300),
            shadowView.heightAnchor.constraint(equalToConstant: 300 * photoModel.aspectRatio),
            
            imageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor, constant: -4),
            dateLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: 16),
            
            locationLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: 4),
            locationLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: -4),
            locationLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            
            downloadsLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor, constant: 4),
            downloadsLabel.trailingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: -4),
            downloadsLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            downloadsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            
            likeButton.widthAnchor.constraint(equalToConstant: 100),
            likeButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            likeButton.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor, constant: 8),
            
//            infoLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 4),
//            infoLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -4),
//            infoLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 8),
//            infoLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
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
        authorNameLabel.text = photoModel.authorName
        
        // Загружаем изображение без использования фреймворка
        if let imageURL = photoModel.smallImage {
            downloadImage(with: imageURL)
        } else {
            imageView.image = nil
        }
        
        dateLabel.text = photoModel.createdDate
        locationLabel.text = photoModel.location
        
        if photoModel.downloadsCount != 0 {
            downloadsLabel.text = "\(photoModel.downloadsCount) downloads"
            downloadsLabel.isHidden = false
        } else {
            downloadsLabel.isHidden = true
        }
    }
    
//    @objc func saveImage(gesture: UILongPressGestureRecognizer) {
//        guard let image = imageView.image else { return }
//        if gesture.state == .began {
//            UIImageWriteToSavedPhotosAlbum(image, self,
//                                           #selector(showAlert(_: didFinishSavingWithError: contextInfo:)), nil)
//        }
//    }
    
//    private func setupSaveGesture() {
//        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(saveImage))
//        gesture.minimumPressDuration = 0.5
//        imageView.addGestureRecognizer(gesture)
//    }
    
    private func showFavoriteStatusAlert() {
        // Создаем сообщение для UIAlertController
        let message = isfavorite ? "Фото добавлено в избранное" : "Фото удалено из избранного"

        // Создаем UIAlertController
        let alertController = UIAlertController(title: "Успех", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))

        // Показываем UIAlertController
        present(alertController, animated: true, completion: nil)
    }
}
