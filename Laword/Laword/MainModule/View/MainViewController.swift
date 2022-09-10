//
//  ViewController.swift
//  Laword
//
//  Created by Ildar Khabibullin on 26.08.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet var LabelFirst: UILabel!
    @IBOutlet var LabelSecond: UILabel!
    @IBOutlet var LabelStart: UILabel!
    @IBOutlet var EasyButton: UIButton!
    @IBOutlet var DifficultButton: UIButton!
    @IBOutlet var DontKnowButton: UIButton!
    
    //    var storeManager = DataStoreManager()
    //    var context = storeManager.persistentContainer.viewContext
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var wordDictionary: [String : AnyObject]!
    var count = 0
    var countWords = 0 //Count total words loaded to DB
    var maxCount = 5
    
    var wordKeys: [NSManagedObject] = []
    var fetchedWords: [Word?]!
    var selectedWord: Word!
    var toggle = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getDataFromFile()
        LabelFirst.isHidden = true
        LabelSecond.isHidden = true
        LabelStart.text = "Нажмите, легко"
        LabelStart.isHidden = false
        
        fetchedWords = getWords(showKey: false)
    }
    
    private func getDataFromFile() {
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
        
        guard let pathToFile = Bundle.main.path(forResource: "wordsdef", ofType: "plist"), let dataArray = NSArray(contentsOfFile: pathToFile) else { return }
        for dictionary in dataArray {
            guard let entity = NSEntityDescription.entity(forEntityName: "Word", in: context) else { return }
            let selectedWord = NSManagedObject(entity: entity, insertInto: context) as! Word
            let wordDictionary = dictionary as! [String : AnyObject]
            selectedWord.word = wordDictionary["wordEN"] as? String
            selectedWord.wordTranslation = wordDictionary["wordRU"] as? String
            countWords += 1
            
        }
        print("Всего загружено в базу: \(countWords) слова")
    }
      
    @IBAction func easyButton(_ sender: Any) {
        guard let selectedWord = fetchedWords?[count] else { return }
        let key = "Easy"
        showAnswers(selectedWord, key)
    }
    
    @IBAction func difficultButton(_ sender: Any) {
        guard let selectedWord = fetchedWords?[count] else { return }
        let key = "Difficult"
        showAnswers(selectedWord, key)
    }
    
    @IBAction func dontKnowButton(_ sender: Any) {
        guard let selectedWord = fetchedWords?[count] else { return }
        let key = "DontKnow"
        showAnswers(selectedWord, key)
    }
    
    private func showAnswers(_ selectedWord: Word, _ key: String) {
        
        if LabelStart.isHidden == false {
            LabelStart.isHidden = true
            LabelFirst.isHidden = false
            LabelFirst.text = selectedWord.word
            toggle = false
        }
        
        if count <= maxCount {
            LabelFirst.text = selectedWord.word
            LabelSecond.text = selectedWord.wordTranslation
            toggle.toggle()
            
            if toggle == false {
                LabelSecond.isHidden = false
                count += 1
                saveKeys(word: selectedWord.word!, key: key, wordTranslation: selectedWord.wordTranslation!, wordShowed: true)
            } else {
                LabelSecond.isHidden = true
                LabelFirst.text = selectedWord.word
            }
            print(selectedWord.word as Any)
            print(selectedWord.wordTranslation as Any)
            print("Count: \(count)")
            print("Toggle: \(toggle)")
        } else {
            alertFinish()
        }
    }
    
    private func statisticWords(_ searchKey: String) {
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
    
    private func statisticShowWords(_ searchKey: Bool) {
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Word.wordShowed), searchKey])
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
    
    private func alertFinish() {
        let alert = UIAlertController(title: "Вы прошли \(maxCount) слов", message: "Начать заново?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] _ in
            self?.count = 0
            self?.statisticWords("Easy")
            self?.statisticWords("Difficult")
            self?.statisticWords("DontKnow")
            self?.statisticShowWords(true)
        }))
        alert.addAction(UIAlertAction(title: "Нет,показать новые", style: .default, handler: { [weak self] _ in
            
            
        }))
        alert.addAction(UIAlertAction(title: "Закончить", style: .default, handler: { [weak self] _ in
            self?.LabelFirst.isHidden = true
            self?.LabelSecond.isHidden = true
            self?.LabelStart.text = "Вы закончили. Хорошая работа!"
            self?.LabelStart.isHidden = false
            self?.EasyButton.isHidden = true
            self?.DifficultButton.isHidden = true
            self?.DontKnowButton.isHidden = true
        }))
        present(alert,animated: true)
    }
    
    private func getWords(showKey: Bool) -> [Word?] {
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        var fetchedWords: [Word]!
        
//        fetchRequest.predicate = NSPredicate(
//            format: "%K = %d",
//            argumentArray: [#keyPath(Word.wordShowed), showKey])
        do {
            let results = try context.fetch(fetchRequest)
            fetchedWords = results
        } catch {
            print(error.localizedDescription)
        }
        return fetchedWords
    }
    
    private func saveKeys(word: String, key: String, wordTranslation: String, wordShowed: Bool) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Word", in: context) else { return }
        let selectedWord = NSManagedObject(entity: entity, insertInto: context) as! Word
        selectedWord.word = word
        selectedWord.wordKey = key
        selectedWord.wordTranslation = wordTranslation
        selectedWord.wordShowed = wordShowed
        do {
            try context.save()
        } catch let error as NSError {
            print("Не могу записать. \(error), \(error.userInfo)")
        }
    }
}
