//
//  SceneDelegate.swift
//  Unsplash
//
//  Created by Алексей Попов on 12.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        window.makeKeyAndVisible()
        window.rootViewController = MainTabBarVC()
        self.window = window
    }
    
    
    func createTabbar() -> UITabBarController {
        let tabBar = UITabBarController()        
        return tabBar
    }
    
    func configureNavigationBar() {
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

}

