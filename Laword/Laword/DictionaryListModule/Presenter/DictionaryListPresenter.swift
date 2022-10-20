//
//  DictionaryListPresenter.swift
//  Laword
//
//  Created by Ildar Khabibullin on 18.10.2022.
//

import Foundation
//input protocol
protocol DictionaryListViewProtocol: AnyObject {
    func setDictionaryName(dictionaryName: String?)
}
//output protocol
protocol DictionaryListViewPresenterProtocol: AnyObject {
    init(view: DictionaryListViewProtocol, dataStoreManager: DataStoreManagerProtocol, dictionaryName: String?)
    func setDictionaryName()
}

class DictionaryListPresenter: DictionaryListViewPresenterProtocol {
    weak var view: DictionaryListViewProtocol?
    let dataStoreManager: DataStoreManagerProtocol!
    var dictionaryName: String?
    var fetchedShowedWords: [Word]?
    var fetchedWords: [Word]?
    
    required init(view: DictionaryListViewProtocol, dataStoreManager: DataStoreManagerProtocol, dictionaryName: String?) {
        self.view = view
        self.dataStoreManager = dataStoreManager
        self.dictionaryName = dictionaryName
    }
    public func setDictionaryName() {
        self.view?.setDictionaryName(dictionaryName: dictionaryName)
    }
}

 
