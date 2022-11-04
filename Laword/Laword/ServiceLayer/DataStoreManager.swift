//
//  DataStoreManager.swift
//  Laword
//
//  Created by Ildar Khabibullin on 28.08.2022.
//

import Foundation
import CoreData

public enum Grade: Int {
    /// complete blackout.
    case null
    /// incorrect response; the correct one remembered
    case bad
    /// incorrect response; where the correct one seemed easy to recall
    case fail
    /// correct response recalled with serious difficulty
    case pass
    /// correct response after a hesitation
    case good
    /// perfect response
    case bright
}

enum DictionaryError: Error {
    case emptyArray
}

protocol DataStoreManagerProtocol {
    func getWords(showKey: Bool, currentDateTime: TimeInterval, dictionaryName: String) -> [Word]
    func getShownWords(wordShowNow: String) -> [Word]
    func saveKeys(word: String, key: String, wordTranslation: String, wordShowed: Bool, wordShowNow: String, grade: Grade)
    func getDataFromFile(nameOfFileDictionary: String, nameOfDictionary: String)
    func statisticWords(_ searchKey: String)
    func statisticShowWords(_ searchKey: Bool)
    func getNamesOfDictionary() -> [String]?
    func saveContext()
    
    func getAllWordsCount() -> [String: Int]
    func getRemainWordsCount() -> [String: Int]
}

class DataStoreManager: DataStoreManagerProtocol {
    var allWordsInCurrentDictionary: [String : Int] = [:]
    var remainingWordsInCurrentDictionary: [String : Int] = [:]
    
    var countWords = 0
    var wordDictionary: [String : AnyObject]!
    var fetchedWords: [Word]?
    var selectedWord: Word?
    var currentCount = 0

    var namesOfDictionary: [String]? = []
    var countOfDictionaries: Int?
    
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
    
    func getAllWordsCount() -> [String: Int] {
        return allWordsInCurrentDictionary
    }

    func getRemainWordsCount() -> [String: Int] {
        return remainingWordsInCurrentDictionary
    }
        
    func getWords(showKey: Bool, currentDateTime: TimeInterval, dictionaryName: String) -> [Word] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        var fetchedWords: [Word]!
        
        let predicateOfUnshowedWords = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Word.wordShowed), showKey as NSNumber])
        
        let predicateOfDictionary = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Word.dictionary.name), dictionaryName])
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        
        let fromPredicate = NSPredicate(format: "%@ >= %K", dateFrom as NSDate, #keyPath(Word.nextDate))
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Word.nextDate), dateTo! as NSDate)
        let dateAndUnshowedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, predicateOfUnshowedWords, predicateOfDictionary])
        fetchRequest.predicate = dateAndUnshowedPredicate
             
        do {
            let results = try context.fetch(fetchRequest)
            UserDefaults.standard.set(results.count, forKey: "currentAmountOfWords")
            fetchedWords = results
            currentCount = results.count
        } catch let error as NSError {
            print("Не могу получить выборку: \(error), \(error.userInfo)")
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        remainingWordsInCurrentDictionary[dictionaryName] = fetchedWords.count
        UserDefaults.standard.set(remainingWordsInCurrentDictionary, forKey: "remainWordsCount")
        
        UserDefaults.standard.set(remainingWordsInCurrentDictionary, forKey: dictionaryName)
        return fetchedWords
    }

        
    // MARK: - Save keys according to different buttons tapped (Easy, Difficult, DontKnow)
    func saveKeys(word: String, key: String, wordTranslation: String, wordShowed: Bool, wordShowNow: String, grade: Grade) {
        
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        
        let wordPredicate = NSPredicate(format: "word == %@", word)
        let translationPredicate = NSPredicate(format: "wordTranslation == %@", wordTranslation)
        let wordAndTraslationPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [wordPredicate,translationPredicate])
        fetchRequest.predicate = wordAndTraslationPredicate

        do {
            let results = try context.fetch(fetchRequest)
            fetchedWords = results
        } catch {
            print(error.localizedDescription)
        }
        
        guard let selectedWord = fetchedWords?.first else { return }
               
        selectedWord.word = word
        selectedWord.wordKey = key
        selectedWord.wordTranslation = wordTranslation
        selectedWord.wordShowed = wordShowed as NSNumber
        selectedWord.wordShowedNow = wordShowNow
        
        let timeInterval = Date().timeIntervalSince1970
        
//        sm2protocol.sm2Algorythm(flashcard: selectedWord, grade: grade, currentDateTime: timeInterval)
        sm2Algorythm(flashcard: selectedWord, grade: grade, currentDateTime: timeInterval)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Не могу записать. \(error), \(error.userInfo), \(error.localizedDescription)")
        }
    }
    
    func sm2Algorythm(flashcard: Word, grade: Grade, currentDateTime: TimeInterval) {
        let maxQuality = 5
        let easinessFactor = 1.3
        
        let cardGrade = grade.rawValue
        
        if cardGrade < 3 {
            flashcard.repetition = 0
            flashcard.interval = 0
        } else {
            let qualityFactor = Double(maxQuality - cardGrade) // CardGrade.bright.rawValue - grade
            let newEasinessFactor = flashcard.easinessFactor + (0.1 - qualityFactor * (0.08 + qualityFactor * 0.02))
            if newEasinessFactor < easinessFactor {
                flashcard.easinessFactor = easinessFactor
            } else {
                flashcard.easinessFactor = newEasinessFactor
            }
            flashcard.repetition += 1
            switch flashcard.repetition {
                case 1:
                    flashcard.interval = 1
                case 2:
                    flashcard.interval = 6
                default:
                    let newInterval = ceil(Double(flashcard.repetition - 1) * flashcard.easinessFactor)
                    flashcard.interval = Int32(newInterval)
            }
        }
        if cardGrade == 3 {
            flashcard.interval = 0
        }
        let seconds = 60
        let minutes = 60
        let hours = 24
        let dayMultiplier = seconds * minutes * hours
        let extraDays = Int32(dayMultiplier) * flashcard.interval
        let newNexDatetime = currentDateTime + Double(extraDays)
        flashcard.previousDate = flashcard.nextDate
        flashcard.nextDate = Date(timeIntervalSince1970: newNexDatetime)
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
            let results = try context.fetch(request)
            for showed in results {
                print("\(String(describing: showed.word)) - \(showed.wordTranslation ?? "")")
            }
        } catch let error as NSError {
            print("Не могу получить выборку: \(error), \(error.userInfo)")
        }
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
            for showed in results {
                print("\(String(describing: showed.word)) - \(showed.wordTranslation ?? "")")
            }
        } catch {
            print(error.localizedDescription)
        }
        return fetchedShowedNowWords
    }
    
    func getNamesOfDictionary() -> [String]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Dictionary> = Dictionary.fetchRequest()
        namesOfDictionary = []
        do {
            let results = try context.fetch(fetchRequest)
            
            for nameOfDict in results {
                guard let name = nameOfDict.name else { return [] }
                namesOfDictionary?.append(name)
                countOfDictionaries = namesOfDictionary?.count
            }
        } catch {
            print(error.localizedDescription)
        }
        return namesOfDictionary
    }
    
    // MARK: - Get data from file
    func getDataFromFile(nameOfFileDictionary: String, nameOfDictionary: String) {
        let context = persistentContainer.viewContext
        let fetchRequestDictionary: NSFetchRequest<Dictionary> = Dictionary.fetchRequest()
        fetchRequestDictionary.predicate = NSPredicate(format: "name = %@", nameOfDictionary)
        countWords = 0
        var records = 0
        do {
            records = try context.count(for: fetchRequestDictionary)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        guard records == 0 else { return }
           
        guard let entityDictionary = NSEntityDescription.entity(forEntityName: "Dictionary", in: context) else { return }
        let selectedDict = NSManagedObject(entity: entityDictionary, insertInto: context) as! Dictionary
        
        selectedDict.name = nameOfDictionary
                
        guard let pathToFile = Bundle.main.path(forResource: nameOfFileDictionary, ofType: "plist"), let dataArray = NSArray(contentsOfFile: pathToFile) else { return }
        
        for dictionary in dataArray {
        
            guard let entityWord = NSEntityDescription.entity(forEntityName: "Word", in: context) else { return }
            let selectedWord = NSManagedObject(entity: entityWord, insertInto: context) as! Word
            let wordDictionary = dictionary as! [String : AnyObject]
            
            selectedWord.word = wordDictionary["wordEN"] as? String
            selectedWord.wordTranslation = wordDictionary["wordRU"] as? String
            selectedWord.dictionary = selectedDict
            
            countWords += 1
        }
        
        selectedDict.countAllWords = Int16(countWords)
        allWordsInCurrentDictionary[nameOfDictionary] = countWords
        
        UserDefaults.standard.set(allWordsInCurrentDictionary, forKey: "allWordsCount")
        
        UserDefaults.standard.set(allWordsInCurrentDictionary, forKey: nameOfDictionary)
    }
}
