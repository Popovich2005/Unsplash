//
//  MainTabBarVC.swift
//  Unsplash
//
//  Created by Алексей Попов on 12.09.2024.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        tabBar.isTranslucent = true
        let photosVC = PhotosVC()
        let favoritesVC = FavoritesVC()
        let photosImage = UIImage(systemName: "photo.fill.on.rectangle.fill") ?? UIImage()
        let heartImage = UIImage(systemName: "heart") ?? UIImage()
        
        viewControllers = [
            generateNavigationController(rootViewController: photosVC, title: "Случайные фотографии",
                                         image: photosImage),
            generateNavigationController(rootViewController: favoritesVC, title: "Избранное", image: heartImage),
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String,
                                              image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        navigationVC.setNavigationBarHidden(true, animated: true)
        return navigationVC
    }
}

