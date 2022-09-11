//
//  MainPresenter.swift
//  Laword
//
//  Created by Ildar Khabibullin on 11.09.2022.
//

import Foundation

protocol MainViewProtocol: AnyObject { //Output
//    func getWords()
//    func getDataFromFile()
}

protocol MainViewPresenterProtocol: AnyObject { //Input
    init(view: MainViewProtocol, dataStoreManager: DataStoreManagerProtocol)
    func getWords() -> [Word]?
    func getDataFromFile()
    func saveKeys(word: String, key: String, wordTranslation: String, wordShowed: Bool)
    func statisticWords( _ : String)
    func statisticShowWords( _ : Bool)
    var fetchedWords: [Word]? { get set }
}

class MainPresenter: MainViewPresenterProtocol {
    
    var fetchedWords: [Word]?
    weak var view: MainViewProtocol?
    let dataStoreManager: DataStoreManagerProtocol!
    
    required init(view: MainViewProtocol, dataStoreManager: DataStoreManagerProtocol) {
        self.view = view
        self.dataStoreManager = dataStoreManager
        fetchedWords = dataStoreManager.getWords(showKey: false)
        getDataFromFile()
    }
    
    func getWords() -> [Word]? {
        fetchedWords = dataStoreManager.getWords(showKey: false)
        return fetchedWords
    }

    func getDataFromFile()  {
        dataStoreManager.getDataFromFile()
        print("Загружены слова в презентер")
    }
    
    func saveKeys(word: String, key: String, wordTranslation: String, wordShowed: Bool) {
        dataStoreManager.saveKeys(word: word, key: key, wordTranslation: wordTranslation, wordShowed: wordShowed)
    }

    func statisticWords(_ searchKey: String) {
        dataStoreManager.statisticWords(searchKey)
    }
    
    func statisticShowWords(_ searchKey: Bool) {
        dataStoreManager.statisticShowWords(searchKey)
    }
}
