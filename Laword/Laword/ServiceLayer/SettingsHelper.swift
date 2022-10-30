//
//  SettingsHelper.swift
//  Laword
//
//  Created by Ильдар on 30.10.2022.
//

import Foundation

class SettingsBundleHelper {
    struct SettingsBundleKeys {
        static let darkMode = "dark_mode"
//        static let BuildVersionKey = "build_preference"
//        static let AppVersionKey = "version_preference"
    }
    class func setDarkMode() {
        UserDefaults.standard.set(true, forKey: SettingsBundleKeys.darkMode)
//        UserDefaults.standard.set(ColorSchemeOption.dark, forKey: SettingsBundleKeys.darkMode)
//        if UserDefaults.standard.bool(forKey: SettingsBundleKeys.lightDarkMode) {
//            UserDefaults.standard.set(false, forKey: SettingsBundleKeys.lightDarkMode)
//            let appDomain: String? = Bundle.main.bundleIdentifier
//            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
            // reset userDefaults..
            // CoreDataDataModel().deleteAllData()
            // delete all other user data here..
        }
    }
    
//    class func setVersionAndBuildNumber() {
//        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
//        UserDefaults.standard.set(version, forKey: "version_preference")
//        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
//        UserDefaults.standard.set(build, forKey: "build_preference")
//    }
//}
