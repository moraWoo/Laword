//
//  DictionaryListPresenter.swift
//  Laword
//
//  Created by Ildar Khabibullin on 22.10.2022.
//

import Foundation

//input protocol
protocol DictionaryListViewProtocol: AnyObject {
    func setDictionaryName(dictionaryName: String)
    func getNamesOfDictionary() -> [String]?
}
//output protocol
protocol DictionaryListViewPresenterProtocol: AnyObject {
    init(view: DictionaryListViewProtocol, dataStoreManager: DataStoreManagerProtocol, dictionaryName: String)
    func setDictionaryName()
    func getNamesOfDictionary() -> [String]?
}

class DictionaryListPresenter: DictionaryListViewPresenterProtocol {
    weak var view: DictionaryListViewProtocol?
    let dataStoreManager: DataStoreManagerProtocol!
    var dictionaryName = "Base12"
    var namesOfDicts: [String]?
    
    required init(view: DictionaryListViewProtocol, dataStoreManager: DataStoreManagerProtocol, dictionaryName: String) {
        self.view = view
        self.dataStoreManager = dataStoreManager
        self.dictionaryName = dictionaryName
        getNamesOfDictionary()
    }
    public func setDictionaryName() {
        self.view?.setDictionaryName(dictionaryName: dictionaryName)
    }
    
    func getNamesOfDictionary() -> [String]? {
        namesOfDicts = dataStoreManager.getNamesOfDictionary()
        return namesOfDicts
    }
}