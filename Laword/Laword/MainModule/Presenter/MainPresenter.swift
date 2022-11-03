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
    func getWords(showKey: Bool, currentDateTime: TimeInterval, dictionaryName: String) -> [Word]
    func getShownWords(_ wordShowNow: String) -> [Word]?
    func getDataFromFile(nameOfFileDictionary: String, nameOfDictionary: String)
    func saveKeys(word: String, key: String, wordTranslation: String, wordShowed: Bool, wordShowNow: String, grade: Grade)
    func statisticWords( _ : String)
    func statisticShowWords( _ : Bool)
    var fetchedWords: [Word]! { get set }
    var fetchedShowedWords: [Word]? { get set }
    var dictionaryName: String? { get set }
    func getNamesOfDictionary() -> [String]?
    func saveContext()
    
    func getAllWordsCount() -> [String: Int]
    func getRemainWordsCount() -> [String : Int]
}

class MainPresenter: MainViewPresenterProtocol {
    var allWordsInCurrentDictionary: [String : Int]?
    var remainingWordsInCurrentDictionary: [String : Int]?
    
    var fetchedShowedWords: [Word]?
    var fetchedWords: [Word]!
    weak var view: MainViewProtocol?
    let dataStoreManager: DataStoreManagerProtocol!
    let dateTime = Date().timeIntervalSince1970
    var dictionaryName: String?
    
    required init(view: MainViewProtocol, dataStoreManager: DataStoreManagerProtocol) {
        self.view = view
        self.dataStoreManager = dataStoreManager
        
        fetchedWords = dataStoreManager.getWords(showKey: false, currentDateTime: dateTime, dictionaryName: dictionaryName ?? "5000 Oxford Words")
        //You can add new files of dictionaries with words
        getDataFromFile(nameOfFileDictionary: "wordsdef", nameOfDictionary: "5000 Oxford Words")
        getDataFromFile(nameOfFileDictionary: "wordsdef_new", nameOfDictionary: "Demo Dictionary")
    }
    
    func getWords(showKey: Bool, currentDateTime: TimeInterval, dictionaryName: String) -> [Word] {
        fetchedWords = dataStoreManager.getWords(showKey: showKey, currentDateTime: dateTime, dictionaryName: dictionaryName)
        return fetchedWords
    }
    
    func getShownWords(_ wordShowNow: String) -> [Word]? {
        fetchedShowedWords = dataStoreManager.getShownWords(wordShowNow: wordShowNow)
        return fetchedShowedWords
    }
    
    func getDataFromFile(nameOfFileDictionary: String, nameOfDictionary: String)  {
        dataStoreManager.getDataFromFile(nameOfFileDictionary: nameOfFileDictionary, nameOfDictionary: nameOfDictionary)
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

    func getNamesOfDictionary() -> [String]? {
        return dataStoreManager.getNamesOfDictionary()
    }

    func saveContext() {
        saveContext()
    }
    
    func getAllWordsCount() -> [String : Int] {
        let allWords = dataStoreManager.getAllWordsCount()
        print("================--------------> ALLWORDS \(allWords)")
        return allWords
    }

    func getRemainWordsCount() -> [String : Int] {
        let remainWords = dataStoreManager.getRemainWordsCount()
        print("================--------------> REMAINWORDS \(remainWords)")
        return remainWords
    }
}
