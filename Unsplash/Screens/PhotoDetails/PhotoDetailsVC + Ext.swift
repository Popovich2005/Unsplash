//
//  PhotoDetailsVC.swift
//  Unsplash
//
//  Created by Алексей Попов on 13.09.2024.
//

import UIKit

extension PhotoDetailsVC {
    
    func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }
    
    func makeAuthorNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.text = "FirstName SecondName"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return label
    }
    
    func makeShadowView() -> UIView {
        let shadow = UIView()
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.layer.cornerRadius = 8
        shadow.layer.shadowRadius = 6
        shadow.layer.shadowOpacity = 0.8
        shadow.layer.shadowOffset = .zero
        shadow.layer.shadowColor = UIColor.label.cgColor
        return shadow
    }
    
    func makeImageView() -> UIImageView {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 8
        image.backgroundColor = .clear
        image.layer.masksToBounds = true
        return image
    }
    
    func makeDateLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
//        label.text = "30.06.2022"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }
    
    func makeLocationLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
//        label.text = "Moscow"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }
    
    func makeDownloadsLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
//        label.text = "37 downloads"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }
    
    func makeLikeButton() -> UIButton {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.isUserInteractionEnabled = true
        return likeButton
    }
    
//    func makeInfoLabel() -> UILabel {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Долгое нажатие на фотографию сохранит её на вашем устройстве"
//        label.numberOfLines = 2
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        return label
//    }
    
//    func labelDateText() -> UILabel {
//        let labelDate = UILabel()
//        labelDate.translatesAutoresizingMaskIntoConstraints = false
//        labelDate.numberOfLines = 1
//        labelDate.text = "Hello world"
//        labelDate.textAlignment = .left
//        labelDate.font = UIFont.systemFont(ofSize: 14, weight: .light)
//        return labelDate
//    }
    
    @objc func showAlert(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Ошибка!", message: error.localizedDescription,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "ОК", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "", message: "Фото сохранено", preferredStyle: .alert)
            let action = UIAlertAction(title: "ОК", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
}
