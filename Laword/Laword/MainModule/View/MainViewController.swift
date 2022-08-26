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
    
    var word = [NSManagedObject]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    
    @IBAction func Next(_ sender: Any) {
    }
}

