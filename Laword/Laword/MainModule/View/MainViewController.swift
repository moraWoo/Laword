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
    
    //    var storeManager = DataStoreManager()
    //    var context = storeManager.persistentContainer.viewContext
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedWord: Word!
    var wordDictionary: [String : AnyObject]!
    var count = 0
    var maxCount: Int!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getDataFromFile()
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let selectedWord = results.first else { return }
            LabelFirst.text = selectedWord.word
            LabelSecond.text = selectedWord.wordTranslation
        } catch {
            print(error.localizedDescription)
        }
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
        }
    }
    
    @IBAction func Next(_ sender: Any) {
        print("count = \(count)")
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            let selectedWord = results[count]
            maxCount = results.count
            LabelFirst.text = selectedWord.word
            LabelSecond.text = selectedWord.wordTranslation
        } catch {
            print(error.localizedDescription)
        }
        if count < maxCount - 1 {
            count += 1
        } else {
            count = 0
        }
    }
}
