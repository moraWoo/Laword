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

protocol DataStoreManagerProtocol {
    func getWords(showKey: Bool, currentDateTime: TimeInterval) -> [Word]
    func getShownWords(wordShowNow: String) -> [Word]
    func saveKeys(word: String, key: String, wordTranslation: String, wordShowed: Bool, wordShowNow: String, grade: Grade)
    func getDataFromFile()
    func statisticWords(_ searchKey: String)
    func statisticShowWords(_ searchKey: Bool)
}

class DataStoreManager: DataStoreManagerProtocol {
    var countWords = 0
    var wordDictionary: [String : AnyObject]!
//    var sm2protocol: SM2ManagerProtocol!
    var fetchedWords: [Word]!
    var selectedWord: Word?
    
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
    
    func getWords(showKey: Bool, currentDateTime: TimeInterval) -> [Word] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        var fetchedWords: [Word]!
        
        let predicateOfUnshowedWords = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Word.wordShowed), showKey as NSNumber])
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
       
        let fromPredicate = NSPredicate(format: "%@ >= %K", dateFrom as NSDate, #keyPath(Word.nextDate))
        
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Word.nextDate), dateTo! as NSDate)
        let dateAndUnshowedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate,toPredicate,predicateOfUnshowedWords])
        fetchRequest.predicate = dateAndUnshowedPredicate
        
        do {
            let results = try context.fetch(fetchRequest)
            fetchedWords = results
        } catch {
            print(error.localizedDescription)
        }
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
        
        guard let selectedWord = fetchedWords.first else { return }
               
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
    
    // MARK: - Get data from file
    func getDataFromFile() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "word != nil")
        var records = 0
        do {
            records = try context.count(for: fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        guard records == 0 else { return }
        
        guard let pathToFile = Bundle.main.path(forResource: "wordsdef", ofType: "plist"), let dataArray = NSArray(contentsOfFile: pathToFile) else { return }
        for dictionary in dataArray {
            guard let entity = NSEntityDescription.entity(forEntityName: "Word", in: context) else { return }
            guard let selectedWord = NSManagedObject(entity: entity, insertInto: context) as? Word else { return }
            guard let wordDictionary = dictionary as? [String : AnyObject] else { return }
            selectedWord.word = wordDictionary["wordEN"] as? String
            selectedWord.wordTranslation = wordDictionary["wordRU"] as? String
            
            countWords += 1
        }
    }
}
