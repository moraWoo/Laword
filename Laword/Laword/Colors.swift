//
//  Colors.swift
//  Laword
//
//  Created by Ildar Khabibullin on 22.10.2022.
//

import UIKit

enum Theme: Int, CaseIterable {
    case system = 0
    case light
    case dark
}

struct SchemeColor {
    
    let dark: UIColor
    let light: UIColor
       
    func uiColor() -> UIColor {
        return colorWith(scheme: ColorScheme.shared.schemeOption)
    }
    
    func cgColor() -> CGColor {
        return uiColor().cgColor
    }
    
    private func colorWith(scheme: ColorSchemeOption) -> UIColor {
        switch scheme {
            case .dark: return dark
            case .light: return light
        }
    }
    

    
}

extension Theme {
    @Persist(key: "app_theme", defaultValue: Theme.light.rawValue)
    private static var appTheme: Int
    
    func save() {
        Theme.appTheme = self.rawValue
    }
    
    static var current: Theme {
        Theme(rawValue: appTheme) ?? .system
    }
}

extension Theme {
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
            case .light: return .light
            case .dark: return .dark
            case .system: return themeWindow.traitCollection.userInterfaceStyle
        }
    }
    
    func setActive() {
        save()

        UIApplication.shared.windows
            .filter { $0 != themeWindow }
            .forEach { $0.overrideUserInterfaceStyle = userInterfaceStyle }

    }
}


@propertyWrapper
struct Persist<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

struct ColorScheme {
    static let shared = ColorScheme()
    private (set) var schemeOption: ColorSchemeOption
    
    private init() {
        let settingsOfDarkMode = UserDefaults.standard.bool(forKey: "dark_mode")
        print("======ColorScheme")
        if settingsOfDarkMode == true {
            schemeOption = .dark
            print("+++++++++++ dark mode")
        } else {
            schemeOption = .light
            print("+++++++++++ light mode")
        }
    }
}
