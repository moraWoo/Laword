//
//  ConfigureFunctionalButtons.swift
//  Laword
//
//  Created by Ildar Khabibullin on 09.11.2022.
//

import Foundation
import UIKit

// MARK: Change stackView withbuttons to the left or to the right side
extension MainViewController {
    func configureElementsOnScreen(leftMode: Bool, isLandscape: Bool, size: CGFloat) {
        translatesAutoresizingMaskIntoConstr()
        if isLandscape {
            landscapeMode(leftMode: leftMode, size: size)
        } else {
            portraitMode(leftMode: leftMode, size: size)
        }
        stackViewLabelWords.addArrangedSubview(innerStackViewLabelWords)
    }

    func portraitMode(leftMode: Bool, size: CGFloat) {
        addSubviewsStacksAndLabels()
        configurationStackViews()
        stackOfButtons.backgroundColor = .blue
        stackViewLabelWords.backgroundColor = .mainPink
        switch leftMode {
        case true:
                addSubviewsButtonsLeft()
                stackOfButtons.alignment = UIStackView.Alignment.leading
                stackViewWithEasyText.alignment = UIStackView.Alignment.leading
                stackViewWithDifText.alignment = UIStackView.Alignment.leading
                stackViewWithDontText.alignment = UIStackView.Alignment.leading
                switch size {
                case 0...568:
                        print("QQQ case 0...568. leftMode. isLandscape=false")
                        var manageStackViewLabelWordsConstraint: NSLayoutConstraint?
                        manageStackViewLabelWordsConstraint = stackViewLabelWords.topAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.topAnchor,
                            constant: topbarHeight
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackViewLabelWords.trailingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                            constant: -16
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackViewLabelWords.leadingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                            constant: 16
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)


                        manageStackViewLabelWordsConstraint = stackOfButtons.bottomAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                            constant: topbarHeight * -1
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackOfButtons.trailingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                            constant: -16
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackOfButtons.leadingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                            constant: 16
                        )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)
                case 568...667:
                        print("QQQ case 568...667. leftMode. isLandscape=false")
                case 667...812:
                        print("QQQ case 667...812. leftMode. isLandscape=false")
                default:
                        print("QQQ case 812 >. leftMode. isLandscape=false")

                        var manageStackViewLabelWordsConstraint: NSLayoutConstraint?
                        manageStackViewLabelWordsConstraint = stackViewLabelWords.topAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.topAnchor,
                            constant: topbarHeight
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackViewLabelWords.trailingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                            constant: -16
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackViewLabelWords.leadingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                            constant: 16
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)


                        manageStackViewLabelWordsConstraint = stackOfButtons.bottomAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                            constant: topbarHeight * -1
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackOfButtons.trailingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                            constant: -16
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackOfButtons.leadingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                            constant: 16
                        )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)
//                        NSLayoutConstraint.activate([
//                            stackOfButtons.bottomAnchor.constraint(
//                                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
//                                constant: topbarHeight * -1
//                            ),
//                            stackOfButtons.trailingAnchor.constraint(
//                                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
//                                constant: -16
//                            ),
//                            stackOfButtons.leadingAnchor.constraint(
//                                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
//                                constant: 16
//                            )
//                        ])
                }
        case false:
                stackOfButtons.alignment = UIStackView.Alignment.trailing
                stackViewWithEasyText.alignment = UIStackView.Alignment.trailing
                stackViewWithDifText.alignment = UIStackView.Alignment.trailing
                stackViewWithDontText.alignment = UIStackView.Alignment.trailing
                addSubviewsButtonsRight()
                switch size {
                case 0...568:
                        print("QQQ case 0...568. rightMode. isLandscape=false")
                        var manageStackViewLabelWordsConstraint: NSLayoutConstraint?
                        manageStackViewLabelWordsConstraint = stackViewLabelWords.topAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.topAnchor,
                            constant: topbarHeight
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackViewLabelWords.trailingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                            constant: -16
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackViewLabelWords.leadingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                            constant: 16
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)


                        manageStackViewLabelWordsConstraint = stackOfButtons.bottomAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                            constant: topbarHeight * -1
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackOfButtons.trailingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                            constant: -16
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackOfButtons.leadingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                            constant: 16
                        )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)
                case 568...667:
                        print("QQQ case 568...667. rightMode. isLandscape=false")
                case 667...812:
                        print("QQQ case 667...812. rightMode. isLandscape=false")
                default:
                        print("QQQ case 812 >. rightMode. isLandscape=false")
                        var manageStackViewLabelWordsConstraint: NSLayoutConstraint?
                        manageStackViewLabelWordsConstraint = stackViewLabelWords.topAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.topAnchor,
                            constant: topbarHeight
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackViewLabelWords.trailingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                            constant: -16
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackViewLabelWords.leadingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                            constant: 16
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)


                        manageStackViewLabelWordsConstraint = stackOfButtons.bottomAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                            constant: topbarHeight * -1
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackOfButtons.trailingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                            constant: -16
                            )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)

                        manageStackViewLabelWordsConstraint = stackOfButtons.leadingAnchor.constraint(
                            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                            constant: 16
                        )
                        manageStackViewLabelWordsConstraint?.isActive = true
                        manageStackViewLabelWordsConstraint?.priority = UILayoutPriority(rawValue: 999)
//                        NSLayoutConstraint.activate([
//                            stackViewLabelWords.topAnchor.constraint(
//                                equalTo: view.safeAreaLayoutGuide.topAnchor,
//                                constant: topbarHeight
//                            ),
//                            stackViewLabelWords.trailingAnchor.constraint(
//                                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
//                                constant: -16
//                            ),
//                            stackViewLabelWords.leadingAnchor.constraint(
//                                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
//                                constant: 16
//                            )
//                        ])
//                        NSLayoutConstraint.activate([
//                            stackOfButtons.bottomAnchor.constraint(
//                                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
//                                constant: topbarHeight * -1
//                            ),
//                            stackOfButtons.trailingAnchor.constraint(
//                                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
//                                constant: -16
//                            ),
//                            stackOfButtons.leadingAnchor.constraint(
//                                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
//                                constant: 16
//                            )
//                        ])
                }
        }
    }

    func landscapeMode(leftMode: Bool, size: CGFloat) {
        addSubviewsStacksAndLabels()
        configurationStackViews()
        stackOfButtons.backgroundColor = .blue
        stackViewLabelWords.backgroundColor = .mainPink
        switch leftMode {
        case true:
                stackOfButtons.alignment = UIStackView.Alignment.leading
                stackViewWithEasyText.alignment = UIStackView.Alignment.leading
                stackViewWithDifText.alignment = UIStackView.Alignment.leading
                stackViewWithDontText.alignment = UIStackView.Alignment.leading
                addSubviewsButtonsLeft()
                switch size {
                case 0...568:
                        print("QQQ case 0...568. leftMode. isLandscape=true")
                case 568...667:
                        print("QQQ case 568...667. leftMode. isLandscape=true")
                case 667...812:
                        print("QQQ case 667...812. leftMode. isLandscape=true")
                default:
                        print("QQQlm case 812 >. leftMode. isLandscape=true")

                        let widthOfStackViewLabelWord = stackViewLabelWords.frame.width
                        let heightOfStackViewLabelWord = stackViewLabelWords.frame.height

                        let leadingFromViewToStackViewLabelWord =
                        (view.frame.width - stackViewLabelWords.frame.width) / 2

                        NSLayoutConstraint.activate([
                            innerStackViewLabelWords.topAnchor.constraint(
                                equalTo: view.safeAreaLayoutGuide.topAnchor,
                                constant: topbarHeight
                            ),
                            innerStackViewLabelWords.trailingAnchor.constraint(
                                equalTo: view.safeAreaLayoutGuide.centerXAnchor,
                                constant: leadingFromViewToStackViewLabelWord
                            )
                        ])

                        NSLayoutConstraint.activate([
                            stackOfButtons.centerYAnchor.constraint(
                                equalTo: view.centerYAnchor),
                            stackOfButtons.leadingAnchor.constraint(
                                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                constant: 16)
                        ])
                }
        case false:
                addSubviewsButtonsRight()
                stackOfButtons.alignment = UIStackView.Alignment.trailing
                stackViewWithEasyText.alignment = UIStackView.Alignment.trailing
                stackViewWithDifText.alignment = UIStackView.Alignment.trailing
                stackViewWithDontText.alignment = UIStackView.Alignment.trailing
                let widthOfStackOfButtons = stackOfButtons.frame.width
                let widthOfStackViewLabelWord = (view.frame.width - widthOfStackOfButtons)
                let leadingFromViewToStackViewLabelWord = widthOfStackViewLabelWord / 2
                switch size {
                case 0...568:
                        print("QQQ case 0...568. rightMode. isLandscape=true")
                        NSLayoutConstraint.activate([
                            stackViewLabelWords.topAnchor.constraint(
                                equalTo: view.safeAreaLayoutGuide.topAnchor,
                                constant: topbarHeight
                            ),
                            stackViewLabelWords.leadingAnchor.constraint(
                                equalTo: view.safeAreaLayoutGuide.centerXAnchor,
                                constant: leadingFromViewToStackViewLabelWord * -1
                            ),
                            stackViewLabelWords.widthAnchor.constraint(equalToConstant: widthOfStackViewLabelWord / 2)
                        ])
                        NSLayoutConstraint.activate([
                            stackOfButtons.centerYAnchor.constraint(
                                equalTo: view.centerYAnchor),
                            stackOfButtons.trailingAnchor.constraint(
                                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                constant: -16)

                        ])
                case 568...667:
                        print("QQQ case 568...667. rightMode. isLandscape=true")
                case 667...812:
                        print("QQQ case 667...812. rightMode. isLandscape=true")
                default:

                        print("QQQ widthOfStackOfButtons = \(widthOfStackOfButtons)")
                        print("QQQ widthOfStackViewLabelWord = \(widthOfStackViewLabelWord)")
                        print("QQQ leadingFromViewToStackViewLabelWord = \(leadingFromViewToStackViewLabelWord)")

                        print("QQQ leadingFromViewToStackViewLabelWord \(leadingFromViewToStackViewLabelWord)")
                        print("QQQ widthOfStackViewLabelWord \(widthOfStackViewLabelWord)")

                        print("QQQ case 812 >. rightMode. isLandscape=true")

                        NSLayoutConstraint.activate([
                            stackViewLabelWords.topAnchor.constraint(
                                equalTo: view.safeAreaLayoutGuide.topAnchor,
                                constant: topbarHeight
                            ),
                            stackViewLabelWords.leadingAnchor.constraint(
                                equalTo: view.safeAreaLayoutGuide.centerXAnchor,
                                constant: leadingFromViewToStackViewLabelWord * -1
                            ),
                            stackViewLabelWords.widthAnchor.constraint(equalToConstant: widthOfStackViewLabelWord / 2)
                        ])
                        NSLayoutConstraint.activate([
                            stackOfButtons.centerYAnchor.constraint(
                                equalTo: view.centerYAnchor),
                            stackOfButtons.trailingAnchor.constraint(
                                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                constant: -16)

                        ])
                }
        }
    }

    private func translatesAutoresizingMaskIntoConstr() {
        stackOfButtons.translatesAutoresizingMaskIntoConstraints = false
        easyLabel.translatesAutoresizingMaskIntoConstraints = false
        easySecondLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultSecondLabel.translatesAutoresizingMaskIntoConstraints = false
        dontKnowLabel.translatesAutoresizingMaskIntoConstraints = false
        dontKnowSecondLabel.translatesAutoresizingMaskIntoConstraints = false
        stackViewWithEasyText.translatesAutoresizingMaskIntoConstraints = false
        stackViewWithDifText.translatesAutoresizingMaskIntoConstraints = false
        stackViewWithDontText.translatesAutoresizingMaskIntoConstraints = false
        easyButton.translatesAutoresizingMaskIntoConstraints = false
        difficultButton.translatesAutoresizingMaskIntoConstraints = false
        dontKnowButton.translatesAutoresizingMaskIntoConstraints = false
        stackViewLabelWords.translatesAutoresizingMaskIntoConstraints = false
        labelFirst.translatesAutoresizingMaskIntoConstraints = false
        labelSecond.translatesAutoresizingMaskIntoConstraints = false
    }

    func addSubviewsButtonsLeft() {
        // MARK: Add buttons and stackviews with label to views
        viewOfEasyButton.addArrangedSubview(easyButton)
        viewOfEasyButton.addArrangedSubview(stackViewWithEasyText)
        viewOfDifficultButton.addArrangedSubview(difficultButton)
        viewOfDifficultButton.addArrangedSubview(stackViewWithDifText)
        viewOfDontKnowButton.addArrangedSubview(dontKnowButton)
        viewOfDontKnowButton.addArrangedSubview(stackViewWithDontText)
    }

    func addSubviewsButtonsRight() {
        // MARK: Add buttons and stackviews with label to views
        viewOfEasyButton.addArrangedSubview(stackViewWithEasyText)
        viewOfEasyButton.addArrangedSubview(easyButton)
        viewOfDifficultButton.addArrangedSubview(stackViewWithDifText)
        viewOfDifficultButton.addArrangedSubview(difficultButton)
        viewOfDontKnowButton.addArrangedSubview(stackViewWithDontText)
        viewOfDontKnowButton.addArrangedSubview(dontKnowButton)
    }

    private func addSubviewsStacksAndLabels() {
        view.addSubview(stackOfButtons)

        // MARK: Add 3 view to StackView (stackOfButtons)
        stackOfButtons.addArrangedSubview(viewOfEasyButton)
        stackOfButtons.addArrangedSubview(viewOfDifficultButton)
        stackOfButtons.addArrangedSubview(viewOfDontKnowButton)

        // MARK: Add Labels to StackView
        stackViewWithEasyText.addArrangedSubview(easyLabel)
        stackViewWithEasyText.addArrangedSubview(easySecondLabel)
        stackViewWithDifText.addArrangedSubview(difficultLabel)
        stackViewWithDifText.addArrangedSubview(difficultSecondLabel)
        stackViewWithDontText.addArrangedSubview(dontKnowLabel)
        stackViewWithDontText.addArrangedSubview(dontKnowSecondLabel)

        stackOfButtons.addArrangedSubview(viewOfEasyButton)
        stackOfButtons.addArrangedSubview(viewOfDifficultButton)
        stackOfButtons.addArrangedSubview(viewOfDontKnowButton)
    }

    private func configurationStackViews() {
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

        // MARK: Configure stackViews with labels
        stackViewWithEasyText.axis = NSLayoutConstraint.Axis.vertical
        stackViewWithEasyText.distribution = UIStackView.Distribution.equalSpacing
        stackViewWithEasyText.spacing = 10

        stackViewWithDifText.axis = NSLayoutConstraint.Axis.vertical
        stackViewWithDifText.distribution = UIStackView.Distribution.equalSpacing
        stackViewWithDifText.spacing = 10

        stackViewWithDontText.axis = NSLayoutConstraint.Axis.vertical
        stackViewWithDontText.distribution = UIStackView.Distribution.equalSpacing
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

        // MARK: Configure stackOfButtons
        stackOfButtons.axis = NSLayoutConstraint.Axis.vertical
        stackOfButtons.distribution = UIStackView.Distribution.equalSpacing
    }

    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}
