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
    @IBOutlet var WordTranscription: UILabel!

    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var nameOfVocabulary: UILabel!
    @IBOutlet weak var countOfWords: UILabel!
    @IBOutlet var LabelStart: UILabel!

    @IBOutlet var EasyButton: UIButton!
    @IBOutlet var DifficultButton: UIButton!
    @IBOutlet var DontKnowButton: UIButton!

    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet weak var countOfLearningWords: UILabel!
    
    @IBOutlet var EasyLabel: UILabel!
    @IBOutlet var EasySecondLabel: UILabel!
    
    @IBOutlet var DifficultLabel: UILabel!
    @IBOutlet var DifficultSecondLabel: UILabel!
    
    @IBOutlet var DontKnowLabel: UILabel!
    @IBOutlet var DontKnowSecondLabel: UILabel!
    
    var presenter: MainViewPresenterProtocol!
    
    var count = 0
    var maxCount = 5
    
    var wordKeys: [NSManagedObject] = []
    var fetchedWords: [Word]!
    var fetchedShownWords: [Word]!
    var selectedWord: Word!
    var toggle = true
    var progressCount = 0.0
    let yesKey = "Yes"
    let dateTime = Date().timeIntervalSince1970
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LabelStart.text = "Тапните по экрану, чтобы начать"
        LabelStart.isHidden = false
        
        hideEverything()
        
        fetchedWords = presenter.getWords(false, dateTime)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture))
        view.addGestureRecognizer(tapRecognizer)
        progressBar.progress = 0
    }
    
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        if EasyButton.isHidden == true {
            view.resignFirstResponder()
            print("Tapped")
            guard let selectedWord = fetchedWords?[count] else { return }
            showAnswers(selectedWord)
            showTopButtonsAndInformation()
        }
    }
    
    @IBAction func easyButton(_ sender: Any) {
        guard let selectedWord = fetchedWords?[count] else { return }
        let key = "Easy"
        presenter.saveKeys(word: selectedWord.word!, key: key, wordTranslation: selectedWord.wordTranslation!, wordShowed: true, wordShowNow: "Yes", grade: Grade.bright)
        showAnswers(selectedWord)
        print("Easy written")
    }
    
    @IBAction func difficultButton(_ sender: Any) {
        guard let selectedWord = fetchedWords?[count] else { return }
        let key = "Difficult"
        presenter.saveKeys(word: selectedWord.word!, key: key, wordTranslation: selectedWord.wordTranslation!, wordShowed: true, wordShowNow: "Yes", grade: Grade.good)
        showAnswers(selectedWord)
    }
    
    @IBAction func dontKnowButton(_ sender: Any) {
        guard let selectedWord = fetchedWords?[count] else { return }
        let key = "DontKnow"
        presenter.saveKeys(word: selectedWord.word!, key: key, wordTranslation: selectedWord.wordTranslation!, wordShowed: true, wordShowNow: "Yes", grade: Grade.null)
        showAnswers(selectedWord)
    }
    
    private func showAnswers(_ selectedWord: Word) {
        progressBar.isHidden = false
        countOfLearningWords.isHidden = false
        
        if LabelStart.isHidden == false {
            LabelStart.isHidden = true
            LabelFirst.isHidden = false
            LabelFirst.text = selectedWord.word
            countOfLearningWords.text = String(count + 1) + "/" + String(maxCount)
            progressCount = Double(count) / Double(maxCount)
            print("Count: \(count), maxCount: \(maxCount), progressCount: \(progressCount)")
            progressBar.progress = Float(progressCount)
            toggle = false
        }
        
        if count < maxCount {
            LabelFirst.text = selectedWord.word
            LabelSecond.text = selectedWord.wordTranslation
            
            hideFunctionButtonsAndLabels()
            toggle.toggle()
            
            if toggle == false {
                showFunctionButtonsAndLabels()
                count += 1
                progressCount = Double(count) / Double(maxCount)
                print("Count: \(count), maxCount: \(maxCount), progressCount: \(progressCount)")
                progressBar.progress = Float(progressCount)
                countOfLearningWords.text = String(count) + "/" + String(maxCount)
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
    
    private func alertFinish() {
        let alert = UIAlertController(title: "Вы прошли \(maxCount) слов", message: "Показать новые?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [self] _ in
            self.count = 0
            hideEverything()
    
            self.LabelStart.isHidden = false
            self.LabelStart.text = "Тапните, чтобы начать"
            
            self.fetchedWords = presenter.getWords(false, dateTime)
            print("fetchedWords: \(String(describing: fetchedWords))")
                    }))
        
        alert.addAction(UIAlertAction(title: "Закончить", style: .default, handler: { [self] _ in
            hideEverything()
            self.LabelStart.isHidden = false
            self.LabelStart.text = "Вы закончили. Хорошая работа!"
        }))
        present(alert,animated: true)
    }
}

extension MainViewController: MainViewProtocol {
    func getWords(){
        print("getWords from MainController")
    }

    func getDataFromFile() {
        print("getDataFromFile fromMainController")
    }
}

extension MainViewController {
    func hideEverything() {
        LabelFirst.isHidden = true
        LabelSecond.isHidden = true
         
        settingsButton.isHidden = true
        menuButton.isHidden = true
        nameOfVocabulary.isHidden = true
        countOfWords.isHidden = true
        
        EasyButton.isHidden = true
        DifficultButton.isHidden = true
        DontKnowButton.isHidden = true
        
        EasyLabel.isHidden = true
        EasySecondLabel.isHidden = true
        DifficultLabel.isHidden = true
        DifficultSecondLabel.isHidden = true
        DontKnowLabel.isHidden = true
        DontKnowSecondLabel.isHidden = true
        
        WordTranscription.isHidden = true
        countOfLearningWords.isHidden = true
        progressBar.isHidden = true
    }
    
    func showTopButtonsAndInformation() {
        settingsButton.isHidden = false
        menuButton.isHidden = false
        nameOfVocabulary.isHidden = false
        countOfWords.isHidden = false
    }
    
    func hideFunctionButtonsAndLabels() {
        EasyButton.isHidden = true
        DifficultButton.isHidden = true
        DontKnowButton.isHidden = true
        
        EasyLabel.isHidden = true
        EasySecondLabel.isHidden = true
        DifficultLabel.isHidden = true
        DifficultSecondLabel.isHidden = true
        DontKnowLabel.isHidden = true
        DontKnowSecondLabel.isHidden = true
    }
    
    func showFunctionButtonsAndLabels() {
        LabelSecond.isHidden = false
        
        EasyButton.isHidden = false
        DifficultButton.isHidden = false
        DontKnowButton.isHidden = false
        
        EasyLabel.isHidden = false
        EasySecondLabel.isHidden = false
        DifficultLabel.isHidden = false
        DifficultSecondLabel.isHidden = false
        DontKnowLabel.isHidden = false
        DontKnowSecondLabel.isHidden = false
    }
}
