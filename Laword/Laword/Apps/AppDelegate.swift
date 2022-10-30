//
//  AppDelegate.swift
//  Laword
//
//  Created by Ildar Khabibullin on 26.08.2022.
//

import UIKit
import CoreData


final class ThemeWindow: UIWindow {
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if Theme.current == .system {
            DispatchQueue.main.async {
                Theme.system.setActive()
            }
        }
    }
}

let themeWindow = ThemeWindow()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        themeWindow.makeKey()
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    SettingsBundleHelper.setDarkMode()
//    SettingsBundleHelper.setVersionAndBuildNumber()
    }

}

