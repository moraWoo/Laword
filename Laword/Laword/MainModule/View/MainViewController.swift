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
    
    @IBOutlet var stackViewLabelWords: UIStackView!
    
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
    
    @IBOutlet var stackOfButtons: UIStackView!
    
    @IBOutlet var viewOfEasyButton: UIStackView!
    @IBOutlet var viewOfDifficultButton: UIStackView!
    @IBOutlet var viewOfDontKnowButton: UIStackView!
    
    @IBOutlet var stackViewWithEasyText: UIStackView!
    @IBOutlet var stackViewWithDifText: UIStackView!
    @IBOutlet var stackViewWithDontText: UIStackView!
    
    var stackOfButtonsConstraints: NSLayoutConstraint?
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    var presenter: MainViewPresenterProtocol!
    var presenterSettings: SettingsViewPresenterProtocol!
    
    var count = 0
    var maxCount = UserDefaults.standard.integer(forKey: "amountOfWords")
    var progressCount = 0.0
    var currentCountWordsInProgress = 0
    
    var currentAmountOfWords: Int? {
        didSet {
            countOfLearningWords.text = String(currentAmountOfWords ?? 0) + "/" + String(maxCount)
        }
    }
    
    var countOfAllWords: Int?
    var countOfRemainWords: Int? {
        didSet {
            subtitleLabel.text = "\(countOfRemainWords ?? 0) " + "/" + " \(countOfAllWords ?? 0)"
        }
    }
    
    var fetchedWords: [Word]?
    var selectedWord: Word?
    
    let dateTime = Date().timeIntervalSince1970
    
    var currentDict: Int?
    var nameOfCurrentDictionary: String?
    var currentNameOfDict: String?
    
    lazy var titleStackView: UIStackView = {
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 12)
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("count__1 = viewDidLoad = \(count)")
        addButtonsAndLabelsToNavigatorBar()
        progressBar.progress = 0
        hideEverything()
        currentDict = UserDefaults.standard.integer(forKey: "currentDictionary")
        guard let namesOfDictionary = presenter.getNamesOfDictionary() else { return }
        
        titleLabel.text = namesOfDictionary[currentDict ?? 0]
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapRecognizer)
        
        if screenHeight < 740 {
            stackViewLabelWords.spacing = 30
        } else {
            stackViewLabelWords.spacing = 120
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if view.traitCollection.horizontalSizeClass == .compact {
            titleStackView.axis = .vertical
            titleStackView.spacing = UIStackView.spacingUseDefault
        } else {
            titleStackView.axis = .horizontal
            titleStackView.spacing = 20.0
        }
        
        currentCountWordsInProgress = UserDefaults.standard.integer(forKey: "currentCountWordsInProgress")
        if currentCountWordsInProgress == 0 {
            count = 0
        }
            
        print("count__3 = viewWillAppear = \(count)")
        print("count__3.1 = currentCountWordsInProgress = \(currentCountWordsInProgress)")
        
        nameOfCurrentDictionary = UserDefaults.standard.object(forKey: "currentDictionary") as? String ?? ""
        let currentDictionary = presenter.getCurrentDictionary(nameOfDictionary: nameOfCurrentDictionary ?? "")
        //Check each dictionary Is there any new word
        if currentDictionary?.countOfRemainWords == 0 {
            alertFinishWordsInCurrentDict()
            return
        }
        
        startLearning(nameOfCurrentDictionary ?? "")
        titleLabel.text = nameOfCurrentDictionary
        
        guard let currentDictionary = presenter.getCurrentDictionary(nameOfDictionary: nameOfCurrentDictionary ?? "") else { return }

        countOfAllWords = Int(currentDictionary.countOfAllWords ?? 0)
        countOfRemainWords = Int(currentDictionary.countOfRemainWords ?? 0)
        
        subtitleLabel.text = "\(currentDictionary.countOfRemainWords ?? 0) " + "/" + " \(currentDictionary.countOfAllWords ?? 0)"

        addButtonsAndLabelsToNavigatorBar()
        navigationItem.titleView = titleStackView
               
        hideEverything()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapRecognizer)
        
        let leftRightMode = UserDefaults.standard.bool(forKey: "leftMode")
        changeConstraintsOfStackButtons(leftMode: leftRightMode)
        
        LabelFirst.isHidden = false
    }
    
    func startLearning(_ dictionaryName: String) {
        print("count__4 = startLearning = \(count)")
        
        maxCount = UserDefaults.standard.integer(forKey: "amountOfWords")
        fetchedWords = presenter.getWords(showKey: false, currentDateTime: dateTime, dictionaryName: dictionaryName)
        
        guard (fetchedWords?[count]) != nil else { return }
        selectedWord = fetchedWords?[count]
        
        LabelFirst.text = selectedWord?.word
        LabelSecond.text = selectedWord?.wordTranslation
        
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
        guard let selectedWord = self.selectedWord else { return }
        showAnswers("showWordFirst", selectedWord)
        print("count__5 = handleTapGesture = \(count)")
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
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            afterButtonPressed(key: "Easy", grade: .bright)
        } else if sender.tag == 1 {
            afterButtonPressed(key: "Difficult", grade: .good)
        } else {
            afterButtonPressed(key: "DontKnow", grade: .null)
        }
        print("count__5.1 = buttonPressed = \(count)")
    }
    
    func afterButtonPressed(key: String, grade: Grade) {
        print("count__6 = afterButtonPressed = \(count)")
        guard let word = selectedWord?.word else { return }
        guard let wordTranslation = selectedWord?.wordTranslation else { return }
        presenter.saveKeys(word: word, key: key, wordTranslation: wordTranslation, wordShowed: true, wordShowNow: "Yes", grade: grade)
        
        count += 1
        
        if count == currentAmountOfWords {
            alertFinishWordsInCurrentDict()
        } else {
            guard (fetchedWords?[count]) != nil else { return }
            selectedWord = fetchedWords?[count]
            guard let selectedWord = self.selectedWord else { return }
            showAnswers("showWordSecond", selectedWord)
        }
        
        countProgressBar()
        countOfRemainWords = (countOfRemainWords ?? 0) - 1
        // MARK: Save remaining words
        presenter.saveCountOfRemainWords(nameOfDictionary: nameOfCurrentDictionary ?? "", remainWords: countOfRemainWords ?? 0)
    }

    private func showAnswers(_ viewState: String, _ selectedWord: Word) {
        switch viewState {
            case "showWordFirst":
                showTopButtonsAndInformation()
                showFunctionButtonsAndLabels()
            default:
                if currentAmountOfWords ?? 0 > maxCount {
                    if count < maxCount {
                        showFunctionButtonsAndLabels()
                        hideFunctionButtonsAndLabels()
                        LabelFirst.text = selectedWord.word
                        LabelSecond.text = selectedWord.wordTranslation
                    } else {
                        alertFinish()
                    }
                } else {
                    if count < currentAmountOfWords ?? 0 {
                        showFunctionButtonsAndLabels()
                        hideFunctionButtonsAndLabels()
                        LabelFirst.text = selectedWord.word
                        LabelSecond.text = selectedWord.wordTranslation
                    } else {
                        alertFinish()
                    }
                }
        }
    }
 
    func countProgressBar() {
        print("count__7 = countProgressBar = \(count)")
        currentAmountOfWords = UserDefaults.standard.integer(forKey: "currentAmountOfWords")
        print("currentAmountOfWords \(UserDefaults.standard.integer(forKey: "currentAmountOfWords"))")
        if currentAmountOfWords ?? 0 > maxCount {
            progressCount = Double(count) / Double(maxCount)
            progressBar.progress = Float(progressCount)
            countOfLearningWords.text = String(count) + "/" + String(maxCount)
        } else {
            progressCount = Double(count) / Double(currentAmountOfWords ?? 0)
            progressBar.progress = Float(progressCount)
            countOfLearningWords.text = String(count) + "/" + String(currentAmountOfWords ?? 0)
            UserDefaults.standard.set(currentAmountOfWords, forKey: "currentAmountOfWords")
        }
        print("count__7.1 = countProgressBar2 = \(count)")
    }
    
    private func alertFinish() {
        let alert = UIAlertController(title: "Вы прошли \(maxCount) слов", message: "Показать новые?", preferredStyle: .alert)
        print("count__8 = alertFinish = \(count)")
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [self] _ in
            hideEverything()
            currentDict = UserDefaults.standard.integer(forKey: "currentDictionary")
            guard let namesOfDictionary = presenter.getNamesOfDictionary() else { return }
            count = 0
            startLearning(namesOfDictionary[currentDict ?? 0])
            count = 0
            progressBar.progress = 0
            print("count__8 = alertFinish_Yes = \(count)")
        }))
        alert.addAction(UIAlertAction(title: "Закончить", style: .default, handler: { [self] _ in
            let dictionaryName = ""
            let dictionaryListVC = ModelBuilder.createDictionaryListModule(dictionaryName: dictionaryName)
            navigationController?.pushViewController(dictionaryListVC, animated: true)
            count = 0
            currentAmountOfWords = 0
            progressBar.progress = 0
            print("count__9 = alertFinish_Finish = \(count)")
        }))
        present(alert,animated: true)
    }
    
    private func alertFinishWordsInCurrentDict() {
        let alert = UIAlertController(title: "Вы прошли все слова", message: "Выберите новый словарь", preferredStyle: .alert)
        print("count__10 = alertFinishWordsInCurrentDict = \(count)")
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { [self] _ in
            let dictionaryName = ""
            let dictionaryListVC = ModelBuilder.createDictionaryListModule(dictionaryName: dictionaryName)
            navigationController?.pushViewController(dictionaryListVC, animated: true)
        }))
        
        present(alert,animated: true)
    }
}

extension MainViewController: MainViewProtocol {
    func getWords(){
    }
    
    func getDataFromFile() {
    }
}

extension MainViewController {
    func hideEverything() {
        LabelFirst.isHidden = true
        LabelSecond.isHidden = true

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

//MARK: Change stackView withbuttons to the left or to the right side
extension MainViewController {

    func changeConstraintsOfStackButtons(leftMode: Bool) {
        stackOfButtons.translatesAutoresizingMaskIntoConstraints = false
        EasyLabel.translatesAutoresizingMaskIntoConstraints = false
        EasySecondLabel.translatesAutoresizingMaskIntoConstraints = false
        DifficultLabel.translatesAutoresizingMaskIntoConstraints = false
        DifficultSecondLabel.translatesAutoresizingMaskIntoConstraints = false
        DontKnowLabel.translatesAutoresizingMaskIntoConstraints = false
        DontKnowSecondLabel.translatesAutoresizingMaskIntoConstraints = false
        stackViewWithEasyText.translatesAutoresizingMaskIntoConstraints = false
        stackViewWithDifText.translatesAutoresizingMaskIntoConstraints = false
        stackViewWithDontText.translatesAutoresizingMaskIntoConstraints = false
        EasyButton.translatesAutoresizingMaskIntoConstraints = false
        DifficultButton.translatesAutoresizingMaskIntoConstraints = false
        DontKnowButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackOfButtons)
        
        // MARK: Add 3 view to StackView (stackOfButtons)
        stackOfButtons.addArrangedSubview(viewOfEasyButton)
        stackOfButtons.addArrangedSubview(viewOfDifficultButton)
        stackOfButtons.addArrangedSubview(viewOfDontKnowButton)
        
        // MARK: Add Labels to StackView
        stackViewWithEasyText.addArrangedSubview(EasyLabel)
        stackViewWithEasyText.addArrangedSubview(EasySecondLabel)
        stackViewWithDifText.addArrangedSubview(DifficultLabel)
        stackViewWithDifText.addArrangedSubview(DifficultSecondLabel)
        stackViewWithDontText.addArrangedSubview(DontKnowLabel)
        stackViewWithDontText.addArrangedSubview(DontKnowSecondLabel)
        
        if leftMode {
            // MARK: Add buttons and stackviews with label to views
            viewOfEasyButton.addArrangedSubview(EasyButton)
            viewOfEasyButton.addArrangedSubview(stackViewWithEasyText)
            viewOfDifficultButton.addArrangedSubview(DifficultButton)
            viewOfDifficultButton.addArrangedSubview(stackViewWithDifText)
            viewOfDontKnowButton.addArrangedSubview(DontKnowButton)
            viewOfDontKnowButton.addArrangedSubview(stackViewWithDontText)
            
            // MARK: Configure stackOfButtons
            stackOfButtons.axis = NSLayoutConstraint.Axis.vertical
            stackOfButtons.distribution = UIStackView.Distribution.equalSpacing
            stackOfButtons.alignment = UIStackView.Alignment.leading
            stackOfButtons.spacing = 20
            stackOfButtons.addArrangedSubview(viewOfEasyButton)
            stackOfButtons.addArrangedSubview(viewOfDifficultButton)
            stackOfButtons.addArrangedSubview(viewOfDontKnowButton)

            if screenHeight < 740 {
                NSLayoutConstraint.activate([
                    stackOfButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36.0),
                    stackOfButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    stackOfButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                ])
            } else {
                NSLayoutConstraint.activate([
                    stackOfButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -94.0),
                    stackOfButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    stackOfButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                ])
            }

            // MARK: Configure StackViews with labels
            stackViewWithEasyText.axis = NSLayoutConstraint.Axis.vertical
            stackViewWithEasyText.distribution = UIStackView.Distribution.equalSpacing
            stackViewWithEasyText.alignment = UIStackView.Alignment.center
            stackViewWithEasyText.spacing = 10

            stackViewWithDifText.axis = NSLayoutConstraint.Axis.vertical
            stackViewWithDifText.distribution = UIStackView.Distribution.equalSpacing
            stackViewWithDifText.alignment = UIStackView.Alignment.center
            stackViewWithDifText.spacing = 10

            stackViewWithDontText.axis = NSLayoutConstraint.Axis.vertical
            stackViewWithDontText.distribution = UIStackView.Distribution.equalSpacing
            stackViewWithDontText.alignment = UIStackView.Alignment.center
            stackViewWithDontText.spacing = 10
            
            // MARK: Configure stackViews with buttons and labels
            viewOfEasyButton.axis = NSLayoutConstraint.Axis.horizontal
            viewOfEasyButton.distribution = UIStackView.Distribution.equalSpacing
            viewOfEasyButton.alignment = UIStackView.Alignment.center
            viewOfEasyButton.spacing = 10
            
            viewOfDifficultButton.axis = NSLayoutConstraint.Axis.horizontal
            viewOfDifficultButton.distribution = UIStackView.Distribution.equalSpacing
            viewOfDifficultButton.alignment = UIStackView.Alignment.center
            viewOfDifficultButton.spacing = 10
            
            viewOfDontKnowButton.axis = NSLayoutConstraint.Axis.horizontal
            viewOfDontKnowButton.distribution = UIStackView.Distribution.equalSpacing
            viewOfDontKnowButton.alignment = UIStackView.Alignment.center
            viewOfDontKnowButton.spacing = 10
            
            // MARK: Configure stackViews with labels
            stackViewWithEasyText.axis = NSLayoutConstraint.Axis.vertical
            stackViewWithEasyText.distribution = UIStackView.Distribution.equalSpacing
            stackViewWithEasyText.alignment = UIStackView.Alignment.leading
            stackViewWithEasyText.spacing = 10
            
            stackViewWithDifText.axis = NSLayoutConstraint.Axis.vertical
            stackViewWithDifText.distribution = UIStackView.Distribution.equalSpacing
            stackViewWithDifText.alignment = UIStackView.Alignment.leading
            stackViewWithDifText.spacing = 10
            
            stackViewWithDontText.axis = NSLayoutConstraint.Axis.vertical
            stackViewWithDontText.distribution = UIStackView.Distribution.equalSpacing
            stackViewWithDontText.alignment = UIStackView.Alignment.leading
            stackViewWithDontText.spacing = 10
                                
        } else {
            // MARK: Add buttons and stackviews with label to views
            viewOfEasyButton.addArrangedSubview(stackViewWithEasyText)
            viewOfEasyButton.addArrangedSubview(EasyButton)
            viewOfDifficultButton.addArrangedSubview(stackViewWithDifText)
            viewOfDifficultButton.addArrangedSubview(DifficultButton)
            viewOfDontKnowButton.addArrangedSubview(stackViewWithDontText)
            viewOfDontKnowButton.addArrangedSubview(DontKnowButton)

            // MARK: Configure stackOfButtons
            stackOfButtons.axis = NSLayoutConstraint.Axis.vertical
            stackOfButtons.distribution = UIStackView.Distribution.equalSpacing
            stackOfButtons.alignment = UIStackView.Alignment.trailing
            stackOfButtons.spacing = 20
            stackOfButtons.addArrangedSubview(viewOfEasyButton)
            stackOfButtons.addArrangedSubview(viewOfDifficultButton)
            stackOfButtons.addArrangedSubview(viewOfDontKnowButton)
            
            if screenHeight < 740 {
                NSLayoutConstraint.activate([
                    stackOfButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36.0),
                    stackOfButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    stackOfButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                ])
            } else {
                NSLayoutConstraint.activate([
                    stackOfButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -94.0),
                    stackOfButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    stackOfButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                ])
            }
            
            // MARK: Configure StackViews with labels
            stackViewWithEasyText.axis = NSLayoutConstraint.Axis.vertical
            stackViewWithEasyText.distribution = UIStackView.Distribution.equalSpacing
            stackViewWithEasyText.alignment = UIStackView.Alignment.center
            stackViewWithEasyText.spacing = 10

            stackViewWithDifText.axis = NSLayoutConstraint.Axis.vertical
            stackViewWithDifText.distribution = UIStackView.Distribution.equalSpacing
            stackViewWithDifText.alignment = UIStackView.Alignment.center
            stackViewWithDifText.spacing = 10

            stackViewWithDontText.axis = NSLayoutConstraint.Axis.vertical
            stackViewWithDontText.distribution = UIStackView.Distribution.equalSpacing
            stackViewWithDontText.alignment = UIStackView.Alignment.center
            stackViewWithDontText.spacing = 10
            
            // MARK: Configure stackViews with buttons and labels
            viewOfEasyButton.axis = NSLayoutConstraint.Axis.horizontal
            viewOfEasyButton.distribution = UIStackView.Distribution.equalSpacing
            viewOfEasyButton.alignment = UIStackView.Alignment.center
            viewOfEasyButton.spacing = 10
            
            viewOfDifficultButton.axis = NSLayoutConstraint.Axis.horizontal
            viewOfDifficultButton.distribution = UIStackView.Distribution.equalSpacing
            viewOfDifficultButton.alignment = UIStackView.Alignment.center
            viewOfDifficultButton.spacing = 10
            
            viewOfDontKnowButton.axis = NSLayoutConstraint.Axis.horizontal
            viewOfDontKnowButton.distribution = UIStackView.Distribution.equalSpacing
            viewOfDontKnowButton.alignment = UIStackView.Alignment.center
            viewOfDontKnowButton.spacing = 10
            
            // MARK: Configure stackViews with labels
            stackViewWithEasyText.axis = NSLayoutConstraint.Axis.vertical
            stackViewWithEasyText.distribution = UIStackView.Distribution.equalSpacing
            stackViewWithEasyText.alignment = UIStackView.Alignment.trailing
            stackViewWithEasyText.spacing = 10
            
            stackViewWithDifText.axis = NSLayoutConstraint.Axis.vertical
            stackViewWithDifText.distribution = UIStackView.Distribution.equalSpacing
            stackViewWithDifText.alignment = UIStackView.Alignment.trailing
            stackViewWithDifText.spacing = 10
            
            stackViewWithDontText.axis = NSLayoutConstraint.Axis.vertical
            stackViewWithDontText.distribution = UIStackView.Distribution.equalSpacing
            stackViewWithDontText.alignment = UIStackView.Alignment.trailing
            stackViewWithDontText.spacing = 10
        }
    }
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}
