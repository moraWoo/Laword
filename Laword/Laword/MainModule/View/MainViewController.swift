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

    @IBOutlet var LabelStart: UILabel!

    @IBOutlet var EasyButton: UIButton!
    @IBOutlet var DifficultButton: UIButton!
    @IBOutlet var DontKnowButton: UIButton!

    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet weak var countOfLearningWords: UILabel!
    
    @IBOutlet var EasyLabel: UILabel!
    @IBOutlet var EasyLabel1: UILabel!
    
    @IBOutlet var DifficultLabel: UILabel!
    @IBOutlet var DifficultLabel1: UILabel!
    
    @IBOutlet var DontKnowLabel: UILabel!
    @IBOutlet var DontKnowLabel1: UILabel!
    
    
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
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        LabelFirst.isHidden = true
        LabelSecond.isHidden = true
        LabelStart.text = "Тапните по экрану, чтобы начать"
        LabelStart.isHidden = false
        
        EasyButton.isHidden = true
        DifficultButton.isHidden = true
        DontKnowButton.isHidden = true
        
        EasyLabel.isHidden = true
        EasyLabel1.isHidden = true
        DifficultLabel.isHidden = true
        DifficultLabel1.isHidden = true
        DontKnowLabel.isHidden = true
        DontKnowLabel1.isHidden = true
        
        WordTranscription.isHidden = true
        
        fetchedWords = presenter.getWords(false)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture))
        view.addGestureRecognizer(tapRecognizer)
        progressBar.isHidden = true
        progressBar.progress = 0
        countOfLearningWords.isHidden = true
        
    }
    
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        if EasyButton.isHidden == true {
            view.resignFirstResponder()
            print("Tapped")
            guard let selectedWord = fetchedWords?[count] else { return }
            showAnswers(selectedWord)
        }
    }
    
    @IBAction func easyButton(_ sender: Any) {
        guard let selectedWord = fetchedWords?[count] else { return }
        let key = "Easy"
        presenter.saveKeys(word: selectedWord.word!, key: key, wordTranslation: selectedWord.wordTranslation!, wordShowed: true, wordShowNow: "Yes")
        showAnswers(selectedWord)
        print("Easy written")
    }
    
    @IBAction func difficultButton(_ sender: Any) {
        guard let selectedWord = fetchedWords?[count] else { return }
        let key = "Difficult"
        presenter.saveKeys(word: selectedWord.word!, key: key, wordTranslation: selectedWord.wordTranslation!, wordShowed: true, wordShowNow: "Yes")
        showAnswers(selectedWord)
    }
    
    @IBAction func dontKnowButton(_ sender: Any) {
        guard let selectedWord = fetchedWords?[count] else { return }
        let key = "DontKnow"
        presenter.saveKeys(word: selectedWord.word!, key: key, wordTranslation: selectedWord.wordTranslation!, wordShowed: true, wordShowNow: "Yes")
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
            toggle = false
        }
        
        if count < maxCount {
            LabelFirst.text = selectedWord.word
            LabelSecond.text = selectedWord.wordTranslation
            
            EasyButton.isHidden = true
            DifficultButton.isHidden = true
            DontKnowButton.isHidden = true
            
            EasyLabel.isHidden = true
            EasyLabel1.isHidden = true
            DifficultLabel.isHidden = true
            DifficultLabel1.isHidden = true
            DontKnowLabel.isHidden = true
            DontKnowLabel1.isHidden = true
            
            toggle.toggle()
            
            if toggle == false {
                LabelSecond.isHidden = false
                
                EasyButton.isHidden = false
                DifficultButton.isHidden = false
                DontKnowButton.isHidden = false
                
                EasyLabel.isHidden = false
                EasyLabel1.isHidden = false
                DifficultLabel.isHidden = false
                DifficultLabel1.isHidden = false
                DontKnowLabel.isHidden = false
                DontKnowLabel1.isHidden = false
                
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
        let alert = UIAlertController(title: "Вы прошли \(maxCount) слов", message: "Начать заново?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [self] _ in
            self.count = 0
            self.presenter.statisticWords("Easy")
            self.presenter.statisticWords("Difficult")
            self.presenter.statisticWords("DontKnow")
            self.presenter.statisticShowWords(true)
            

            self.progressBar.progress = 0
            self.LabelSecond.isHidden = true
            self.LabelFirst.isHidden = true
            
            self.EasyButton.isHidden = true
            self.DifficultButton.isHidden = true
            self.DontKnowButton.isHidden = true
                     
            self.EasyLabel.isHidden = true
            self.EasyLabel1.isHidden = true
            self.DifficultLabel.isHidden = true
            self.DifficultLabel1.isHidden = true
            self.DontKnowLabel.isHidden = true
            self.DontKnowLabel1.isHidden = true
            
            
            self.LabelStart.isHidden = false
            self.LabelStart.text = "Тапните, чтобы начать заново"
            self.fetchedShownWords = presenter.getShownWords(self.yesKey)
            

        }))
        alert.addAction(UIAlertAction(title: "Нет,показать новые", style: .default, handler: { [self] _ in
            print("Показал новые")
            self.fetchedWords = presenter.getWords(false)
            print("fetchedWords: \(String(describing: fetchedWords))")
            
                    }))
        alert.addAction(UIAlertAction(title: "Закончить", style: .default, handler: { [self] _ in
            self.LabelFirst.isHidden = true
            self.LabelSecond.isHidden = true
            self.LabelStart.isHidden = false
            self.LabelStart.text = "Вы закончили. Хорошая работа!"
            
            self.EasyButton.isHidden = true
            self.DifficultButton.isHidden = true
            self.DontKnowButton.isHidden = true
            
            self.EasyLabel.isHidden = true
            self.EasyLabel1.isHidden = true
            self.DifficultLabel.isHidden = true
            self.DifficultLabel1.isHidden = true
            self.DontKnowLabel.isHidden = true
            self.DontKnowLabel1.isHidden = true
            
            self.progressBar.isHidden = true
            self.countOfLearningWords.isHidden = true
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
