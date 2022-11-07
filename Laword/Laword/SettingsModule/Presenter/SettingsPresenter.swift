//
//  SettingsPresenter.swift
//  Laword
//
//  Created by Ильдар on 23.10.2022.
//

import Foundation

//input protocol
protocol SettingsViewProtocol: AnyObject {
}
//output protocol
protocol SettingsViewPresenterProtocol: AnyObject {
    init(view: SettingsViewProtocol, dataStoreManager: DataStoreManagerProtocol)
}

class SettingsPresenter: SettingsViewPresenterProtocol {
    weak var view: SettingsViewProtocol!
    let dataStoreManager: DataStoreManagerProtocol!

    required init(view: SettingsViewProtocol, dataStoreManager: DataStoreManagerProtocol) {
        self.view = view
        self.dataStoreManager = dataStoreManager
    }
}
