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
    func getWords(_ searchKey: Bool,_ currentDateTime: TimeInterval) -> [Word]?
    func getShownWords(_ wordShowNow: String) -> [Word]?
    func getDataFromFile()
    func saveKeys(word: String, key: String, wordTranslation: String, wordShowed: Bool, wordShowNow: String, grade: Grade)
    func statisticWords( _ : String)
    func statisticShowWords( _ : Bool)
    var fetchedWords: [Word]? { get set }
    var fetchedShowedWords: [Word]? { get set }
}

class MainPresenter: MainViewPresenterProtocol {

    var fetchedShowedWords: [Word]?
    var fetchedWords: [Word]?
    weak var view: MainViewProtocol?
    let dataStoreManager: DataStoreManagerProtocol!
    let dateTime = Date().timeIntervalSince1970
    
    required init(view: MainViewProtocol, dataStoreManager: DataStoreManagerProtocol) {
        self.view = view
        self.dataStoreManager = dataStoreManager
        fetchedWords = dataStoreManager.getWords(showKey: false, currentDateTime: dateTime)
        getDataFromFile()
    }
    
    func getWords(_ searchKey: Bool, _ dateTime: TimeInterval) -> [Word]? {
        fetchedWords = dataStoreManager.getWords(showKey: searchKey, currentDateTime: dateTime)
        return fetchedWords
    }
    
    func getShownWords(_ wordShowNow: String) -> [Word]? {
        fetchedShowedWords = dataStoreManager.getShownWords(wordShowNow: wordShowNow)
        return fetchedShowedWords
    }
    
    func getDataFromFile()  {
        dataStoreManager.getDataFromFile()
    }
    
    func saveKeys(word: String, key: String, wordTranslation: String, wordShowed: Bool, wordShowNow: String, grade: Grade) {
        dataStoreManager.saveKeys(word: word, key: key, wordTranslation: wordTranslation, wordShowed: wordShowed, wordShowNow: wordShowNow, grade: grade)
    }

    func statisticWords(_ searchKey: String) {
        dataStoreManager.statisticWords(searchKey)
    }
    
    func statisticShowWords(_ searchKey: Bool) {
        dataStoreManager.statisticShowWords(searchKey)
    }
    
    
}
