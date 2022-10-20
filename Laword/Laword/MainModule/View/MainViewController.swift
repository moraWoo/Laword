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
    
    var presenter: MainViewPresenterProtocol?
    var count = 0
    let maxCount = 5
    var fetchedWords: [Word]?
    var progressCount = 0.0
    let dateTime = Date().timeIntervalSince1970
    var selectedWord: Word?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.progress = 0
        
        hideEverything()
        startLearning()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func startLearning() {
        guard let fetchedWords = presenter?.getWords(false, dateTime) else { return }
        selectedWord = fetchedWords[count]
        guard let selectedWord = selectedWord else { return }
        LabelFirst.text = selectedWord.word
        LabelSecond.text = selectedWord.wordTranslation
        
        showTopButtonsAndInformation()
        countProgressBar()
    }
    
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        view.resignFirstResponder()
        guard let selectedWord = fetchedWords?[count] else { return }
        showAnswers("showWordFirst", selectedWord)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            afterButtonPressed(key: "Easy", grade: .bright)
        } else if sender.tag == 1 {
            afterButtonPressed(key: "Difficult", grade: .good)
        } else {
            afterButtonPressed(key: "DontKnow", grade: .null)
        }
    }

    func afterButtonPressed(key: String, grade: Grade) {
        
        if count == 0 {
            guard let selectedWord = fetchedWords?[count] else { return }
            guard let word = selectedWord.word else { return }
            guard let wordTranslation = selectedWord.wordTranslation else { return }
            presenter?.saveKeys(word: word, key: key, wordTranslation: wordTranslation, wordShowed: true, wordShowNow: "Yes", grade: grade)
            
            count += 1
            guard let selectedWord = fetchedWords?[count] else { return }
            showAnswers("showWordSecond", selectedWord)

            guard let word = selectedWord.word else { return }
            guard let wordTranslation = selectedWord.wordTranslation else { return }
            presenter?.saveKeys(word: word, key: key, wordTranslation: wordTranslation, wordShowed: true, wordShowNow: "Yes", grade: grade)
            
            countProgressBar()
            
        } else {
            count += 1
            guard let selectedWord = fetchedWords?[count] else { return }
            showAnswers("showWordSecond", selectedWord)
            guard let word = selectedWord.word else { return }
            guard let wordTranslation = selectedWord.wordTranslation else { return }
            presenter?.saveKeys(word: word, key: key, wordTranslation: wordTranslation, wordShowed: true, wordShowNow: "Yes", grade: grade)
            countProgressBar()
        }
    }
    
    private func showAnswers(_ viewState: String, _ selectedWord: Word) {
        switch viewState {
            case "showWordFirst":
                showTopButtonsAndInformation()
                showFunctionButtonsAndLabels()
            default:
                if count < maxCount {
                    showFunctionButtonsAndLabels()
                    hideFunctionButtonsAndLabels()
                    LabelFirst.text = selectedWord.word
                    LabelSecond.text = selectedWord.wordTranslation
                 } else {
                    alertFinish()
            }
        }
    }
 
    func countProgressBar() {
        progressCount = Double(count) / Double(maxCount)
        progressBar.progress = Float(progressCount)
        countOfLearningWords.text = String(count) + "/" + String(maxCount)
    }
    
    private func alertFinish() {
        let alert = UIAlertController(title: "Вы прошли \(maxCount) слов", message: "Показать новые?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [self] _ in
            self.count = 0
            hideEverything()
            startLearning()
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
        //        print("getWords from MainController")
    }
    
    func getDataFromFile() {
        //        print("getDataFromFile fromMainController")
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
        LabelFirst.isHidden = false
        LabelStart.isHidden = true
        progressBar.isHidden = false
        countOfLearningWords.isHidden = false
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
        LabelSecond.isHidden = true
        
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

extension UIView {
    
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MyAssociatedObjectKeyForTapGesture"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
}
