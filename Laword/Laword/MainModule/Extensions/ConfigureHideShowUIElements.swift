//
//  ConfigureHideShowUIElements.swift
//  Laword
//
//  Created by Ildar Khabibullin on 09.11.2022.
//

import Foundation
import UIKit

extension MainViewController {
    func hideEverything() {
        labelFirst.isHidden = true
        labelSecond.isHidden = true

        easyButton.isHidden = true
        difficultButton.isHidden = true
        dontKnowButton.isHidden = true

        easyLabel.isHidden = true
        easySecondLabel.isHidden = true
        difficultLabel.isHidden = true
        difficultSecondLabel.isHidden = true
        dontKnowLabel.isHidden = true
        dontKnowSecondLabel.isHidden = true

        wordTranscription.isHidden = true
        countOfLearningWords.isHidden = true
        progressBar.isHidden = true
    }

    func showTopButtonsAndInformation() {
        labelFirst.isHidden = false
        labelStart.isHidden = true
        progressBar.isHidden = false
        countOfLearningWords.isHidden = false
    }

    func hideFunctionButtonsAndLabels() {
        easyButton.isHidden = true
        difficultButton.isHidden = true
        dontKnowButton.isHidden = true

        easyLabel.isHidden = true
        easySecondLabel.isHidden = true
        difficultLabel.isHidden = true
        difficultSecondLabel.isHidden = true
        dontKnowLabel.isHidden = true
        dontKnowSecondLabel.isHidden = true
        labelSecond.isHidden = true
    }

    func showFunctionButtonsAndLabels() {
        labelSecond.isHidden = false

        easyButton.isHidden = false
        difficultButton.isHidden = false
        dontKnowButton.isHidden = false

        easyLabel.isHidden = false
        easySecondLabel.isHidden = false
        difficultLabel.isHidden = false
        difficultSecondLabel.isHidden = false
        dontKnowLabel.isHidden = false
        dontKnowSecondLabel.isHidden = false
    }
}
