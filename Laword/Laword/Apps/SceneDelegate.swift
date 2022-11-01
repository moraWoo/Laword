//
//  SceneDelegate.swift
//  Laword
//
//  Created by Ildar Khabibullin on 26.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowsScene.coordinateSpace.bounds)
        window?.windowScene = windowsScene
        let mainVC = ModelBuilder.createMainModule()
        let navBar = UINavigationController(rootViewController: mainVC)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        navBar.navigationBar.standardAppearance = appearance
        navBar.navigationBar.scrollEdgeAppearance = appearance
        
        window?.rootViewController = navBar
//        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
    }
}

