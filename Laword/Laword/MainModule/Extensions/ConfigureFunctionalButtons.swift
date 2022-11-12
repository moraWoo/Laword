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
    func changeConstraintsOfStackButtons(leftMode: Bool) {
        translatesAutoresizingMaskIntoConstr()
        addSubviewsStacksAndLabels()

        if leftMode {
            configureStackOfButtons()
            stackOfButtons.alignment = UIStackView.Alignment.leading
            addSubviewsButtonsLeft()
            addArrangeSubviewsOfStackOfButtons()

            configurationOfViewsButtons()

            setupConstraints()

            layoutTrait(traitCollection: UIScreen.main.traitCollection)

            configureStackViewWithText()
            stackViewWithEasyText.alignment = UIStackView.Alignment.leading
            stackViewWithDifText.alignment = UIStackView.Alignment.leading
            stackViewWithDontText.alignment = UIStackView.Alignment.leading
        } else {
            configureStackOfButtons()
            stackOfButtons.alignment = UIStackView.Alignment.trailing
            addSubviewsButtonsRight()

            addArrangeSubviewsOfStackOfButtons()

            configurationOfViewsButtons()

            setupConstraints()

            layoutTrait(traitCollection: UIScreen.main.traitCollection)

            configureStackViewWithText()
            stackViewWithEasyText.alignment = UIStackView.Alignment.trailing
            stackViewWithDifText.alignment = UIStackView.Alignment.trailing
            stackViewWithDontText.alignment = UIStackView.Alignment.trailing
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
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        countOfLearningWords.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureStackViewWithText() {
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
    }

    private func configurationOfViewsButtons() {
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

    private func addArrangeSubviewsOfStackOfButtons() {
        stackOfButtons.addArrangedSubview(viewOfEasyButton)
        stackOfButtons.addArrangedSubview(viewOfDifficultButton)
        stackOfButtons.addArrangedSubview(viewOfDontKnowButton)
    }

    private func configureStackOfButtons() {
        // MARK: Configure stackOfButtons
        stackOfButtons.axis = NSLayoutConstraint.Axis.vertical
        stackOfButtons.distribution = UIStackView.Distribution.equalSpacing
        stackOfButtons.spacing = 10
    }

    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        countOfLearningWords.contentMode = .center

        // MARK: Compact Constraints (Portrait Mode)
        compactConstraints.append(contentsOf: [
            stackViewLabelWords.topAnchor.constraint(lessThanOrEqualTo: safeArea.topAnchor, constant: border * 2),
            stackViewLabelWords.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: border),
            stackViewLabelWords.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: border * -1),

            stackOfButtons.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: border
            ),
            stackOfButtons.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: border * -1
            ),
            stackOfButtons.bottomAnchor.constraint(equalTo: countOfLearningWords.topAnchor),

            progressBar.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: border),
            progressBar.trailingAnchor.constraint(
                equalTo: countOfLearningWords.leadingAnchor),
            progressBar.centerYAnchor.constraint(
                equalTo: countOfLearningWords.centerYAnchor),

            countOfLearningWords.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: border * -1),
            countOfLearningWords.widthAnchor.constraint(equalToConstant: border * 3),
            countOfLearningWords.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: border * -1),
            countOfLearningWords.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: border * -1)
        ])

        // MARK: Regular Constraints (Landscape Mode)
        regularConstraints.append(contentsOf: [
            stackViewLabelWords.topAnchor.constraint(lessThanOrEqualTo: safeArea.topAnchor, constant: border * 2),
            stackViewLabelWords.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: border),
            stackViewLabelWords.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.5),
            stackViewLabelWords.bottomAnchor.constraint(lessThanOrEqualTo: countOfLearningWords.topAnchor),

            stackOfButtons.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackOfButtons.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: border * -1),

            progressBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: countOfLearningWords.leadingAnchor),
            progressBar.centerYAnchor.constraint(equalTo: countOfLearningWords.centerYAnchor),

            countOfLearningWords.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: border * -1),
            countOfLearningWords.widthAnchor.constraint(equalToConstant: border * 3),
            countOfLearningWords.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: border * -1),
            countOfLearningWords.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: border * -1)
        ])
    }

    func layoutTrait(traitCollection: UITraitCollection) {
        switch orientationScreen {
        case .landscapeRight:
                print("landscapeRight")
        case .portrait:
                print("portrait")
        case .landscapeLeft:
                print("landscapeLeft")
        case .unknown:
                print("Unknown orientation")
        case .faceDown:
                print("FaceDown orientation")
        case .faceUp:
                print("FaceUp orientation")
        default:
                print("PortraitUpsideDown orientation")
        }

        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if regularConstraints.count > 0 && regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            UserDefaults.standard.set(true, forKey: "switchOfLeftModeIsActive")
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            if compactConstraints.count > 0 && compactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            UserDefaults.standard.set(false, forKey: "switchOfLeftModeIsActive")
            NSLayoutConstraint.activate(regularConstraints)
        }
    }
}
