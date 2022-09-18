//
//  DataStoreManager.swift
//  Laword
//
//  Created by Ildar Khabibullin on 28.08.2022.
//

import Foundation
import CoreData

protocol DataStoreManagerProtocol {
    func getWords(showKey: Bool) -> [Word]
    func getShownWords(wordShowNow: String) -> [Word]
    func saveKeys(word: String, key: String, wordTranslation: String, wordShowed: Bool, wordShowNow: String)
    func getDataFromFile()
    func statisticWords(_ searchKey: String)
    func statisticShowWords(_ searchKey: Bool)
}

class DataStoreManager: DataStoreManagerProtocol {
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Laword")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - CRUD
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getWords(showKey: Bool) -> [Word] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        var fetchedWords: [Word]!
       
        fetchRequest.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Word.wordShowed), showKey as NSNumber])
        
        do {
            let results = try context.fetch(fetchRequest)
            fetchedWords = results
            print("Отобранные слова, которые еще не показывали: \(fetchedWords.count)")
            for showed in results {
                print("\(String(describing: showed.word)) - \(showed.wordTranslation ?? "")")
            }
        } catch {
            print(error.localizedDescription)
        }
        return fetchedWords
    }
    
    func getShownWords(wordShowNow: String) -> [Word] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        var fetchedShowedNowWords: [Word]!
       
        fetchRequest.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Word.wordShowedNow), wordShowNow])
        
        do {
            let results = try context.fetch(fetchRequest)
            fetchedShowedNowWords = results
            print("Отобранные слова, которые еще не показывали: \(fetchedShowedNowWords.count)")
            for showed in results {
                print("\(String(describing: showed.word)) - \(showed.wordTranslation ?? "")")
            }
        } catch {
            print(error.localizedDescription)
        }
        return fetchedShowedNowWords
    }
    
    // MARK: - Get data from file
    func getDataFromFile() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "word != nil")
        
        var records = 0
        do {
            records = try context.count(for: fetchRequest)
            print("Is Data there already?")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        guard records == 0 else { return }
        
        let dictionaryDB = Dictionary(context: context)
        dictionaryDB.name = "BaseDictionary"
        
        guard let pathToFile = Bundle.main.path(forResource: "wordsdef", ofType: "plist"), let dataArray = NSArray(contentsOfFile: pathToFile) else { return }
        
        for dictionary in dataArray {
            guard let entity = NSEntityDescription.entity(forEntityName: "Word", in: context) else { return }
            guard let selectedWord = NSManagedObject(entity: entity, insertInto: context) as? Word else { return }
            guard let wordDictionary = dictionary as? [String: AnyObject] else { return }

            selectedWord.word = wordDictionary["wordEN"] as? String
            selectedWord.wordTranslation = wordDictionary["wordRU"] as? String
            
            selectedWord.dictionary = dictionaryDB //Write for each word to the dictionary #1
        }

        //Show words in context
        do {
            let results = try context.fetch(fetchRequest)
            let dictName = results[0].dictionary?.name
            print("Всего загружено в базу: \(results.count) слов, в словарь: \(String(describing: dictName))")
            print("Следующие слова были загружены в словарь: \(String(describing: dictName))")
            for showed in results {
                print("\(String(describing: showed.word)) - \(showed.wordTranslation ?? "")")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
        
    // MARK: - Save keys according to different buttons tapped (Easy, Difficult, DontKnow)
    func saveKeys(word: String, key: String, wordTranslation: String, wordShowed: Bool, wordShowNow: String) {
        let context = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Word", in: context) else { return }
        let selectedWord = NSManagedObject(entity: entity, insertInto: context) as! Word
        selectedWord.word = word
        selectedWord.wordKey = key
        selectedWord.wordTranslation = wordTranslation
        selectedWord.wordShowed = wordShowed as NSNumber
        selectedWord.wordShowedNow = wordShowNow
        do {
            try context.save()
        } catch let error as NSError {
            print("Не могу записать. \(error), \(error.userInfo)")
        }
    }
    
    func statisticWords(_ searchKey: String) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Word.wordKey), searchKey])
        do {
            // Получить выборку
            let results = try context.fetch(request)
            print("Просмотренные слова по ключу \(searchKey)")
            for showed in results {
                print("\(String(describing: showed.word)) - \(showed.wordTranslation ?? "")")
            }
        } catch let error as NSError {
            print("Не могу получить выборку: \(error), \(error.userInfo)")
        }
    }
    
    func statisticShowWords(_ searchKey: Bool) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Word.wordShowed), searchKey as NSNumber])
        do {
            // Получить выборку
            let results = try context.fetch(request)
            print("Все просмотренные слова:")
            for showed in results {
                print("\(String(describing: showed.word)) - \(showed.wordTranslation ?? "")")
            }
        } catch let error as NSError {
            print("Не могу получить выборку: \(error), \(error.userInfo)")
        }
    }
}
