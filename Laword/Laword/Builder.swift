//
//  Builder.swift
//  Laword
//
//  Created by Ildar Khabibullin on 11.09.2022.
//

import UIKit

protocol Builder {
    static func createMainModule() -> UIViewController
}

class ModelBuilder: Builder {
    static func createMainModule() -> UIViewController {
        let view = MainViewController()
        let dataStoreManager = DataStoreManager()
        let presenter = MainPresenter(view: view, dataStoreManager: dataStoreManager)
        view.presenter = presenter
        return view
    }
}
