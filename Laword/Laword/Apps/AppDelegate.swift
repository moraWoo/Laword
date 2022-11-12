//
//  AppDelegate.swift
//  Laword
//
//  Created by Ildar Khabibullin on 26.08.2022.
//

import UIKit

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
    func application(
        _ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let theme = UserDefaults.standard.bool(forKey: "darkMode")

        if theme {
            DispatchQueue.main.async {
                Theme.dark.setActive()
            }
        } else {
            DispatchQueue.main.async {
                Theme.light.setActive()
            }
        }

        themeWindow.makeKey()

        if UserDefaults.standard.object(forKey: "amountOfWords") != nil {
            UserDefaults.standard.bool(forKey: "amountOfWords")
        } else {
            UserDefaults.standard.set(10, forKey: "amountOfWords")
        }

        // Set default dictionary
        UserDefaults.standard.set("5000 Oxford Words", forKey: "currentDictionary")
        UserDefaults.standard.set(true, forKey: "switchOfLeftModeIsActive")
        return true
    }
}
