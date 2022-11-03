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
    static func createOnboardingPage1() -> UIViewController
    static func createOnboardingPage2() -> UIViewController
    static func createOnboardingPage3() -> UIViewController
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
        let view = DictionaryListCollectionViewController(nibName: "DictionaryListCollectionViewController", bundle: nil)
        let dataStoreManager = DataStoreManager()
        let presenter = DictionaryListPresenter(view: view, dataStoreManager: dataStoreManager, dictionaryName: dictionaryName)
        view.presenter = presenter
        return view
    }
    
    static func createSettingsModule() -> UIViewController {
        let view = SettingsViewController()
        let dataStoreManager = DataStoreManager()
        let presenter = SettingsPresenter(view: view, dataStoreManager: dataStoreManager)
        view.presenter = presenter
        return view
    }
    
    static func createOnboardingPage1() -> UIViewController {
        let view = OnboardingViewControllerPage1(nibName: "OnboardingViewController", bundle: nil)
        return view
    }
    
    static func createOnboardingPage2() -> UIViewController {
        let view = OnboardingViewControllerPage2(nibName: "OnboardingViewController", bundle: nil)
        return view
    }
    static func createOnboardingPage3() -> UIViewController {
        let view = OnboardingViewControllerPage3(nibName: "OnboardingViewController", bundle: nil)
        return view
    }
}
