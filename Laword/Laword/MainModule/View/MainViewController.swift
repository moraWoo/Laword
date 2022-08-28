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
    
    var storeManager = DataStoreManager()
    let storeDirectory = NSPersistentContainer.defaultDirectoryURL()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let learnWord = storeManager.obtainMainUser()
//        let learnWord = storeManager.viewContext
        LabelFirst.text = learnWord.word
        LabelSecond.text = learnWord.wordTranslation
        
        print("path: \(storeDirectory)")
        
    }

    @IBAction func Next(_ sender: Any) {
        
    }
}

