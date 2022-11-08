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
    func saveKeys(
        word: String,
        key: String,
        wordTranslation: String,
        wordShowed: Bool,
        wordShowNow: String,
        grade: Grade
    )
    func getDataFromFile(nameOfFileDictionary: String, nameOfDictionary: String)

    func getNamesOfDictionary() -> [String]?
    func saveContext()

    func getCurrentDictionary(nameOfDictionary: String) -> CurrentDictionary?
    func saveCountOfRemainWords(nameOfDictionary: String, remainWords: Int)
}

class DataStoreManager: DataStoreManagerProtocol {

    var allWordsInCurrentDictionary: [String: Int] = [:]
    var remainingWordsInCurrentDictionary: [String: Int] = [:]

    var countWords = 0
    var wordDictionary: [String: AnyObject]!
    var fetchedWords: [Word]?
    var fetchedDicts: [Dictionary]?
    var selectedWord: Word?
    var currentCount = 0

    var namesOfDictionary: [String]? = []
    var countOfDictionaries: Int?

    var currentDictionary: CurrentDictionary?

    // MARK: Get array with name, all words, remain words from CoreData
    func getCurrentDictionary(nameOfDictionary: String) -> CurrentDictionary? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Dictionary> = Dictionary.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)

            for selectedDictionary in results {
                let currentDict = CurrentDictionary(
                    name: selectedDictionary.name,
                    countOfAllWords: selectedDictionary.countAllWords,
                    countOfRemainWords: selectedDictionary.countRemainWords
                )

                if selectedDictionary.name != nameOfDictionary {
                    print("take another dictionary")
                } else {
                    currentDictionary = currentDict
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return currentDictionary
    }

    // MARK: Update values of remaining words in each Dictionary
    func saveCountOfRemainWords(nameOfDictionary: String, remainWords: Int) {
        let context = persistentContainer.viewContext
        let fetchRequestDictionary: NSFetchRequest<Dictionary> = Dictionary.fetchRequest()

        fetchRequestDictionary.predicate = NSPredicate(format: "name = %@", nameOfDictionary)

        do {
            let results = try context.fetch(fetchRequestDictionary)
            fetchedDicts = results
        } catch {
            print(error.localizedDescription)
        }

        guard let selectedDict = fetchedDicts?.first else { return }
        selectedDict.countRemainWords = Int16(remainWords)

        do {
            try context.save()
        } catch let error as NSError {
            print("Can't save. \(error), \(error.userInfo), \(error.localizedDescription)")
        }
    }

    func getWords(showKey: Bool, currentDateTime: TimeInterval, dictionaryName: String) -> [Word] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        var fetchedWords: [Word]?

        let predicateOfDictionary = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Word.dictionary.name), dictionaryName])

        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local

        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)

        let fromPredicate = NSPredicate(format: "%@ >= %K", dateFrom as NSDate, #keyPath(Word.nextDate))
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Word.nextDate), dateTo! as NSDate)

        let dateAndUnshowedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
                                                            [
                                                                fromPredicate,
                                                                toPredicate,
                                                                predicateOfDictionary
                                                            ])
        fetchRequest.predicate = dateAndUnshowedPredicate

        do {
            let results = try context.fetch(fetchRequest)
            UserDefaults.standard.set(results.count, forKey: "currentAmountOfWords")
            fetchedWords = results
            currentCount = results.count
        } catch let error as NSError {
            print("Can't fetch: \(error), \(error.userInfo)")
        }

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        guard let fetched = fetchedWords else {
            fatalError("Unable to dequeue PersonCell.")
        }
        return fetched
    }

    // MARK: - Save keys according to different buttons tapped (Easy, Difficult, DontKnow)
    func saveKeys(
        word: String,
        key: String,
        wordTranslation: String,
        wordShowed: Bool,
        wordShowNow: String,
        grade: Grade) {

        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()

        let wordPredicate = NSPredicate(format: "word == %@", word)
        let translationPredicate = NSPredicate(format: "wordTranslation == %@", wordTranslation)
        let wordAndTraslationPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
                                                                [
                                                                    wordPredicate,
                                                                    translationPredicate
                                                                ])
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

        sm2Algorythm(flashcard: selectedWord, grade: grade, currentDateTime: timeInterval)

        do {
            try context.save()
        } catch let error as NSError {
            print("Can't save. \(error), \(error.userInfo), \(error.localizedDescription)")
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
        guard let entityDictionary = NSEntityDescription.entity(forEntityName: "Dictionary",
                                                                in: context) else { return }
        let selectedDict = NSManagedObject(entity: entityDictionary, insertInto: context) as? Dictionary

        selectedDict?.name = nameOfDictionary

        guard let pathToFile = Bundle.main.path(forResource: nameOfFileDictionary, ofType: "plist"),
              let dataArray = NSArray(contentsOfFile: pathToFile) else { return }

        for dictionary in dataArray {

            guard let entityWord = NSEntityDescription.entity(forEntityName: "Word",
                                                              in: context) else { return }
            let selectedWord = NSManagedObject(entity: entityWord, insertInto: context) as? Word
            let wordDictionary = dictionary as? [String: AnyObject]

            selectedWord?.word = wordDictionary?["wordEN"] as? String
            selectedWord?.wordTranslation = wordDictionary?["wordRU"] as? String
            selectedWord?.dictionary = selectedDict
            countWords += 1
        }
        selectedDict?.countAllWords = Int16(countWords)
        selectedDict?.countRemainWords = Int16(countWords)
    }
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Laword")
        container.loadPersistentStores(completionHandler: { (_, error) in
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
}
