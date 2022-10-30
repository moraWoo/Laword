//
//  ViewController.swift
//  Laword
//
//  Created by Ildar Khabibullin on 26.08.2022.
//

import UIKit
import CoreData

enum ColorSchemeOption {
    case dark
    case light
}

enum ColorAppearence {
    static let backgroudColor = SchemeColor(dark: Dark.backgroundColor, light: Light.backgroundColor)
    static let textColorOfCountWords = SchemeColor(dark: Dark.textColorOfCountWords, light: Light.textColorOfCountWords)
    static let textColor = SchemeColor(dark: Dark.textColor, light: Light.textColor)
    
    private enum Light {
        static let backgroundColor = UIColor.white
        static let textColorOfCountWords = UIColor.systemGray
        static let textColor = UIColor.black
    }
    
    private enum Dark {
        static let backgroundColor = UIColor.black
        static let textColorOfCountWords = UIColor.systemGray
        static let textColor = UIColor.white
    }

}


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
    var presenterSettings: SettingsViewPresenterProtocol!
    var count = 0
    let maxCount = 5
    var fetchedWords: [Word]!
    var progressCount = 0.0
    let dateTime = Date().timeIntervalSince1970
    var selectedWord: Word!
    
    lazy var titleStackView: UIStackView = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = ColorAppearence.textColorOfCountWords.uiColor()
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.text = "Базовый словарь"
        let subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "250 / 4963"
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = ColorAppearence.textColorOfCountWords.uiColor()
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorAppearence.backgroudColor.uiColor()
        addButtonsAndLabelsToNavigatorBar()
        navigationItem.titleView = titleStackView
        progressBar.progress = 0
               
        hideEverything()
        startLearning("5000OxfordWords")
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = ColorAppearence.backgroudColor.uiColor()
        
        if view.traitCollection.horizontalSizeClass == .compact {
            titleStackView.axis = .vertical
            titleStackView.spacing = UIStackView.spacingUseDefault
        } else {
            titleStackView.axis = .horizontal
            titleStackView.spacing = 20.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = ColorAppearence.backgroudColor.uiColor()
        countOfLearningWords.textColor = ColorAppearence.textColorOfCountWords.uiColor()
        EasySecondLabel.textColor = ColorAppearence.textColorOfCountWords.uiColor()
        DifficultSecondLabel.textColor = ColorAppearence.textColorOfCountWords.uiColor()
        DontKnowSecondLabel.textColor = ColorAppearence.textColorOfCountWords.uiColor()
        
        EasyLabel.textColor = ColorAppearence.textColor.uiColor()
        DifficultLabel.textColor = ColorAppearence.textColor.uiColor()
        DontKnowLabel.textColor = ColorAppearence.textColor.uiColor()
        
        LabelFirst.textColor = ColorAppearence.textColor.uiColor()
        LabelSecond.textColor = ColorAppearence.textColor.uiColor()
        WordTranscription.textColor = ColorAppearence.textColorOfCountWords.uiColor()
        
        addButtonsAndLabelsToNavigatorBar()
        navigationItem.titleView = titleStackView
        progressBar.progress = 0
               
        hideEverything()
        startLearning("5000OxfordWords")
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapRecognizer)
        
    }
    
    func startLearning(_ dictionaryName: String) {
        fetchedWords = presenter.getWords(showKey: false, currentDateTime: dateTime, dictionaryName: dictionaryName)
        guard let selectedWord = fetchedWords?[count] else { return }
        let result = selectedWord.dictionary?.name
        print("======== \(String(describing: result))")
        LabelFirst.text = selectedWord.word
        LabelSecond.text = selectedWord.wordTranslation
        
        showTopButtonsAndInformation()
        countProgressBar()
    }
    
    func addButtonsAndLabelsToNavigatorBar() {
        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(UIImage(named: "SettingsButton"), for: .normal)
        settingsButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        settingsButton.addTarget(self, action: #selector(settingsButtonTap), for: .touchUpInside)
        let settingsButtonItem = UIBarButtonItem(customView: settingsButton)
        
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(UIImage(named: "MenuButton"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuButton.addTarget(self, action: #selector(menuButtonTap), for: .touchUpInside)
        let menuButtonItem = UIBarButtonItem(customView: menuButton)
        
        self.navigationItem.setLeftBarButtonItems([settingsButtonItem], animated: true)
        self.navigationItem.setRightBarButtonItems([menuButtonItem], animated: true)
    }
    
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        view.resignFirstResponder()
        guard let selectedWord = fetchedWords?[count] else { return }
        showAnswers("showWordFirst", selectedWord)
    }
    
    @objc private func menuButtonTap(sender: UIButton) {
        let dictionaryName = "Base1"
        let dictionaryListVC = ModelBuilder.createDictionaryListModule(dictionaryName: dictionaryName)
        navigationController?.pushViewController(dictionaryListVC, animated: true)
    }
    
    @objc private func settingsButtonTap(sender: UIButton) {
        let settingsVC = ModelBuilder.createSettingsModule()
        navigationController?.pushViewController(settingsVC, animated: false)
    }
    
    @IBAction func dictionaryListButton(_ sender: Any) {
        let dictionaryName = "Base1"
        let dictionaryListVC = ModelBuilder.createDictionaryListModule(dictionaryName: dictionaryName)
        navigationController?.pushViewController(dictionaryListVC, animated: true)
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
            presenter.saveKeys(word: word, key: key, wordTranslation: wordTranslation, wordShowed: true, wordShowNow: "Yes", grade: grade)
            
            count += 1
            guard let selectedWord = fetchedWords?[count] else { return }
            showAnswers("showWordSecond", selectedWord)

            guard let word = selectedWord.word else { return }
            guard let wordTranslation = selectedWord.wordTranslation else { return }
            presenter.saveKeys(word: word, key: key, wordTranslation: wordTranslation, wordShowed: true, wordShowNow: "Yes", grade: grade)
            countProgressBar()
            
        } else {
            count += 1
            guard let selectedWord = fetchedWords?[count] else { return }
            showAnswers("showWordSecond", selectedWord)
            guard let word = selectedWord.word else { return }
            guard let wordTranslation = selectedWord.wordTranslation else { return }
            presenter.saveKeys(word: word, key: key, wordTranslation: wordTranslation, wordShowed: true, wordShowNow: "Yes", grade: grade)
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
            startLearning("5000OxfordWords")
        }))
        alert.addAction(UIAlertAction(title: "Закончить", style: .default, handler: { [self] _ in
//            hideEverything()
//            self.LabelStart.isHidden = false
//            self.LabelStart.text = "Вы закончили. Хорошая работа!"
            let dictionaryName = "Base1"

            let dictionaryListVC = ModelBuilder.createDictionaryListModule(dictionaryName: dictionaryName)
            navigationController?.pushViewController(dictionaryListVC, animated: true)
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
        
//        settingsButton.isHidden = true
//        menuButton.isHidden = true
//        nameOfVocabulary.isHidden = true
//        countOfWords.isHidden = true
//
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
//        settingsButton.isHidden = false
//        menuButton.isHidden = false
//        nameOfVocabulary.isHidden = false
//        countOfWords.isHidden = false
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

extension UIWindow {
    func initTheme() {
        overrideUserInterfaceStyle = Theme.current.userInterfaceStyle
    }
}

