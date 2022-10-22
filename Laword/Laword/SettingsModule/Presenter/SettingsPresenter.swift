//
//  SettingsPresenter.swift
//  Laword
//
//  Created by Ильдар on 23.10.2022.
//

import Foundation

//input protocol
protocol SettingsViewProtocol: AnyObject {
//    func setDictionaryName(dictionaryName: String)
//    func getNamesOfDictionary() -> [String]?
}
//output protocol
protocol SettingsViewPresenterProtocol: AnyObject {
    init(view: SettingsViewProtocol, dataStoreManager: DataStoreManagerProtocol)
//    func setDictionaryName()
//    func getNamesOfDictionary() -> [String]?
}

class SettingsPresenter: SettingsViewPresenterProtocol {
    weak var view: SettingsViewProtocol?
    let dataStoreManager: DataStoreManagerProtocol!

    required init(view: SettingsViewProtocol, dataStoreManager: DataStoreManagerProtocol) {
        self.view = view
        self.dataStoreManager = dataStoreManager
    }
}
