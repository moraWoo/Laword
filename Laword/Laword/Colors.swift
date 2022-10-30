//
//  Colors.swift
//  Laword
//
//  Created by Ildar Khabibullin on 22.10.2022.
//

import UIKit

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

struct ColorScheme {
    static let shared = ColorScheme()
    private (set) var schemeOption: ColorSchemeOption
    
    private init() {
        let option = UserDefaults.standard.bool(forKey: "dark_mode")
        if option {
            schemeOption = .dark
        } else {
            schemeOption = .light
        }
    }
}
