//
//  DictionaryListPresenter.swift
//  Laword
//
//  Created by Ildar Khabibullin on 22.10.2022.
//

import Foundation

// input protocol
protocol DictionaryListViewProtocol: AnyObject {
    func setDictionaryName(dictionaryName: String)
    func getNamesOfDictionary() -> [String]?
}
// output protocol
protocol DictionaryListViewPresenterProtocol: AnyObject {
    init(view: DictionaryListViewProtocol, dataStoreManager: DataStoreManagerProtocol, dictionaryName: String)
    func setDictionaryName()
    func getNamesOfDictionary() -> [String]?
    func getCurrentDictionary(nameOfDictionary: String) -> CurrentDictionary?
}

class DictionaryListPresenter: DictionaryListViewPresenterProtocol {
    weak var view: DictionaryListViewProtocol?

    var currentDictionary: CurrentDictionary?
    let dataStoreManager: DataStoreManagerProtocol!
    var dictionaryName = ""
    var namesOfDicts: [String]?

    required init(view: DictionaryListViewProtocol,
                  dataStoreManager: DataStoreManagerProtocol,
                  dictionaryName: String) {
        self.view = view
        self.dataStoreManager = dataStoreManager
        self.dictionaryName = dictionaryName
    }

    public func setDictionaryName() {
        self.view?.setDictionaryName(dictionaryName: dictionaryName)
    }

    func getNamesOfDictionary() -> [String]? {
        namesOfDicts = dataStoreManager.getNamesOfDictionary()
        return namesOfDicts
    }
    func getCurrentDictionary(nameOfDictionary: String) -> CurrentDictionary? {
        currentDictionary = dataStoreManager.getCurrentDictionary(nameOfDictionary: nameOfDictionary)
        return currentDictionary
    }
}
