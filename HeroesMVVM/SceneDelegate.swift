//
//  SceneDelegate.swift
//  HeroesMVVM
//
//  Created by Rocio Martos on 25/1/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        //Instanciamos 1r view controller
        let splashVC = SplashViewController()
        //Instanciamos Navigation
        let navigationController = UINavigationController(rootViewController: splashVC)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}

