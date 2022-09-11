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
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet weak var countOfLearningWords: UILabel!
    
    var presenter: MainViewPresenterProtocol!
    
    var count = 0
    var maxCount = 5
    
    var wordKeys: [NSManagedObject] = []
    var fetchedWords: [Word]!
    var selectedWord: Word!
    var toggle = true
    var progressCount = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LabelFirst.isHidden = true
        LabelSecond.isHidden = true
        LabelStart.text = "Тапните по экрану, чтобы начать"
        LabelStart.isHidden = false
        
        EasyButton.isHidden = true
        DifficultButton.isHidden = true
        DontKnowButton.isHidden = true
        
        fetchedWords = presenter.getWords()

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
        presenter.saveKeys(word: selectedWord.word!, key: key, wordTranslation: selectedWord.wordTranslation!, wordShowed: true)
        showAnswers(selectedWord)
        print("Easy written")
    }
    
    @IBAction func difficultButton(_ sender: Any) {
        guard let selectedWord = fetchedWords?[count] else { return }
        let key = "Difficult"
        presenter.saveKeys(word: selectedWord.word!, key: key, wordTranslation: selectedWord.wordTranslation!, wordShowed: true)
        showAnswers(selectedWord)
    }
    
    @IBAction func dontKnowButton(_ sender: Any) {
        guard let selectedWord = fetchedWords?[count] else { return }
        let key = "DontKnow"
        presenter.saveKeys(word: selectedWord.word!, key: key, wordTranslation: selectedWord.wordTranslation!, wordShowed: true)
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
            
            toggle.toggle()
            
            if toggle == false {
                LabelSecond.isHidden = false
                EasyButton.isHidden = false
                DifficultButton.isHidden = false
                DontKnowButton.isHidden = false
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
        
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] _ in
            self?.count = 0
            self?.presenter.statisticWords("Easy")
            self?.presenter.statisticWords("Difficult")
            self?.presenter.statisticWords("DontKnow")
            self?.presenter.statisticShowWords(true)
            self?.progressBar.progress = 0
            self?.LabelSecond.isHidden = true
            self?.LabelFirst.isHidden = true
            self?.EasyButton.isHidden = true
            self?.DifficultButton.isHidden = true
            self?.DontKnowButton.isHidden = true
            self?.LabelStart.isHidden = false
            self?.LabelStart.text = "Тапните, чтобы начать заново"
        }))
        alert.addAction(UIAlertAction(title: "Нет,показать новые", style: .default, handler: { _ in
            print("Показал новые")
        }))
        alert.addAction(UIAlertAction(title: "Закончить", style: .default, handler: { [weak self] _ in
            self?.LabelFirst.isHidden = true
            self?.LabelSecond.isHidden = true
            self?.LabelStart.isHidden = false
            self?.LabelStart.text = "Вы закончили. Хорошая работа!"
            self?.EasyButton.isHidden = true
            self?.DifficultButton.isHidden = true
            self?.DontKnowButton.isHidden = true
            self?.progressBar.isHidden = true
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
