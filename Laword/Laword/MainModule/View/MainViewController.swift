//
//  ViewController.swift
//  Laword
//
//  Created by Ildar Khabibullin on 26.08.2022.
//

import UIKit
import CoreData

enum CurrentOrientation {
    case portrait
    case landscape
}

class MainViewController: UIViewController, MainViewProtocol {

    @IBOutlet var labelFirst: UILabel!
    @IBOutlet var labelSecond: UILabel!
    @IBOutlet var wordTranscription: UILabel!

    @IBOutlet var stackViewLabelWords: UIStackView!
    @IBOutlet var innerStackViewLabelWords: UIStackView!

    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var nameOfVocabulary: UILabel!
    @IBOutlet weak var countOfWords: UILabel!

    @IBOutlet var labelStart: UILabel!

    @IBOutlet var easyButton: UIButton!
    @IBOutlet var difficultButton: UIButton!
    @IBOutlet var dontKnowButton: UIButton!

    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet weak var countOfLearningWords: UILabel!

    @IBOutlet var easyLabel: UILabel!
    @IBOutlet var easySecondLabel: UILabel!

    @IBOutlet var difficultLabel: UILabel!
    @IBOutlet var difficultSecondLabel: UILabel!

    @IBOutlet var dontKnowLabel: UILabel!
    @IBOutlet var dontKnowSecondLabel: UILabel!

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
    var nameOfCurrentDictionary: String?

    let sizeOfBorder: CGFloat = 16

    var screenHeightInPortrait: CGFloat?
    var screenHeightInLandscape: CGFloat?

    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }

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

        let frame = view.safeAreaLayoutGuide.layoutFrame.size

        addButtonsAndLabelsToNavigatorBar()
        progressBar.progress = 0
        hideEverything()

        nameOfCurrentDictionary = UserDefaults.standard.object(forKey: "currentDictionary") as? String ?? ""
        titleLabel.text = nameOfCurrentDictionary ?? ""

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapRecognizer)
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

        nameOfCurrentDictionary = UserDefaults.standard.object(forKey: "currentDictionary") as? String ?? ""

        let currentDictionary = presenter.getCurrentDictionary(nameOfDictionary: nameOfCurrentDictionary ?? "")
        // Check each dictionary. Is there any new word?
        if currentDictionary?.countOfRemainWords == 0 {
            alertFinishWordsInCurrentDict()
            return
        }

        startLearning(nameOfCurrentDictionary ?? "")
        titleLabel.text = nameOfCurrentDictionary

        guard let currentDictionary =
                presenter.getCurrentDictionary(nameOfDictionary: nameOfCurrentDictionary ?? "") else { return }

        countOfAllWords = Int(currentDictionary.countOfAllWords ?? 0)
        countOfRemainWords = Int(currentDictionary.countOfRemainWords ?? 0)

        subtitleLabel.text =
        "\(currentDictionary.countOfRemainWords ?? 0) " + "/" + " \(currentDictionary.countOfAllWords ?? 0)"

        addButtonsAndLabelsToNavigatorBar()
        navigationItem.titleView = titleStackView
        hideEverything()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapRecognizer)

        let leftRightMode = UserDefaults.standard.bool(forKey: "leftMode")
        generalConfig(leftMode: leftRightMode)

        labelFirst.isHidden = false
    }

    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        let leftRightMode = UserDefaults.standard.bool(forKey: "leftMode")
        generalConfig(leftMode: leftRightMode)
    }

    func generalConfig(leftMode: Bool) {
        let leftRightMode = UserDefaults.standard.bool(forKey: "leftMode")

        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            screenHeightInLandscape = view.frame.width
            configureElementsOnScreen(leftMode: leftMode,
                                      isLandscape: true,
                                      size: screenHeightInLandscape ?? 0
            )
        } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            screenHeightInLandscape = view.frame.width
            configureElementsOnScreen(leftMode: leftMode,
                                      isLandscape: true,
                                      size: screenHeightInLandscape ?? 0
            )
        } else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            screenHeightInPortrait = view.frame.height
            configureElementsOnScreen(leftMode: leftMode,
                                      isLandscape: false,
                                      size: screenHeightInPortrait ?? 0
            )
        }
    }

    func startLearning(_ dictionaryName: String) {
        maxCount = UserDefaults.standard.integer(forKey: "amountOfWords")

        fetchedWords = presenter.getWords(showKey: false, currentDateTime: dateTime, dictionaryName: dictionaryName)
        guard (fetchedWords?[count]) != nil else { return }
        selectedWord = fetchedWords?[count]

        labelFirst.text = selectedWord?.word
        labelSecond.text = selectedWord?.wordTranslation
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
    }

    @objc private func menuButtonTap(sender: UIButton) {
        let dictionaryName = ""
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
    }

    func afterButtonPressed(key: String, grade: Grade) {
        guard let word = selectedWord?.word else { return }
        guard let wordTranslation = selectedWord?.wordTranslation else { return }
        presenter.saveKeys(
            word: word,
            key: key,
            wordTranslation: wordTranslation,
            wordShowed: true,
            wordShowNow: "Yes",
            grade: grade
        )
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
        presenter.saveCountOfRemainWords(
            nameOfDictionary: nameOfCurrentDictionary ?? "",
            remainWords: countOfRemainWords ?? 0)
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
                        labelFirst.text = selectedWord.word
                        labelSecond.text = selectedWord.wordTranslation
                    } else {
                        alertFinish()
                    }
                } else {
                    if count < currentAmountOfWords ?? 0 {
                        showFunctionButtonsAndLabels()
                        hideFunctionButtonsAndLabels()
                        labelFirst.text = selectedWord.word
                        labelSecond.text = selectedWord.wordTranslation
                    } else {
                        alertFinish()
                    }
                }
        }
    }

    func countProgressBar() {
        currentAmountOfWords = UserDefaults.standard.integer(forKey: "currentAmountOfWords")
        if currentAmountOfWords ?? 0 > maxCount {
            let progressCount = Double(count) / Double(maxCount)
            progressBar.progress = Float(progressCount)
            countOfLearningWords.text = String(count) + "/" + String(maxCount)
        } else {
            let progressCount = Double(count) / Double(currentAmountOfWords ?? 0)
            progressBar.progress = Float(progressCount)
            countOfLearningWords.text = String(count) + "/" + String(currentAmountOfWords ?? 0)
            UserDefaults.standard.set(currentAmountOfWords, forKey: "currentAmountOfWords")
        }
    }

    private func alertFinish() {
        let alert =
        UIAlertController(
            title: "Вы прошли \(maxCount) слов",
            message: "Показать новые?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [self] _ in
            hideEverything()
            count = 0
            nameOfCurrentDictionary = UserDefaults.standard.object(forKey: "currentDictionary") as? String ?? ""
            startLearning(nameOfCurrentDictionary ?? "")
            count = 0
            progressBar.progress = 0
        }))
        alert.addAction(UIAlertAction(title: "Закончить", style: .default, handler: { [self] _ in
            let dictionaryName = ""
            let dictionaryListVC = ModelBuilder.createDictionaryListModule(dictionaryName: dictionaryName)
            navigationController?.pushViewController(dictionaryListVC, animated: true)
            count = 0
            currentAmountOfWords = 0
            progressBar.progress = 0
        }))
        present(alert, animated: true)
    }

    private func alertFinishWordsInCurrentDict() {
        let alert =
        UIAlertController(
            title: "Вы прошли все слова",
            message: "Выберите новый словарь",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { [self] _ in
            let dictionaryName = ""
            let dictionaryListVC = ModelBuilder.createDictionaryListModule(dictionaryName: dictionaryName)
            navigationController?.pushViewController(dictionaryListVC, animated: true)
        }))

        present(alert, animated: true)
    }
}

extension UIWindow {
    func initTheme() {
        overrideUserInterfaceStyle = Theme.current.userInterfaceStyle
    }
}
