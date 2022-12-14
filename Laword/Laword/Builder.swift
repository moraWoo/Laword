//
//  Builder.swift
//  Laword
//
//  Created by Ildar Khabibullin on 11.09.2022.
//

import UIKit

protocol Builder {
    static func createMainModule() -> UIViewController
    static func createDictionaryListModule(dictionaryName: String) -> UICollectionViewController
    static func createSettingsModule() -> UIViewController
    static func createOnboardingPageVC() -> UIPageViewController
}

class ModelBuilder: Builder {
    static func createMainModule() -> UIViewController {
        let view = MainViewController()
        let dataStoreManager = DataStoreManager()
        let presenter = MainPresenter(view: view, dataStoreManager: dataStoreManager)
        view.presenter = presenter
        return view
    }

    static func createDictionaryListModule(dictionaryName: String) -> UICollectionViewController {
        let view = DictionaryListCollectionViewController(
            nibName: "DictionaryListCollectionViewController",
            bundle: nil)
        let dataStoreManager = DataStoreManager()
        let presenter = DictionaryListPresenter(
            view: view,
            dataStoreManager: dataStoreManager,
            dictionaryName: dictionaryName)
        view.presenter = presenter
        return view
    }

    static func createSettingsModule() -> UIViewController {
        let view = SettingsViewController()
        let dataStoreManager = DataStoreManager()
        let presenter = SettingsPresenter(
            view: view,
            dataStoreManager: dataStoreManager)
        view.presenter = presenter
        return view
    }

    static func createOnboardingPageVC() -> UIPageViewController {
        let view = OnboardingPageViewController(nibName: "OnboardingPageViewController", bundle: nil)
        return view
    }
}
