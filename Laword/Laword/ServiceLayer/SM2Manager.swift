//
//  SM2Manager.swift
//  Laword
//
//  Created by Ildar Khabibullin on 09.10.2022.
//

import Foundation

//protocol sm2ManagerProtocol {
//    func sm2Algorythm(grade: )
//}
//func sm2Algorythm(flashcard: Word, grade: Grade) -> FlashCard {
//    let maxQuality = 5
//    let easinessFactor = 1.3
//    let cardGrade = grade.rawValue
//
//    if cardGrade < 3 {
//        flashcard.repetition = 0
//        flashcard.interval = 0
//    } else {
//        let qualityFactor = Double(maxQuality - cardGrade) // CardGrade.bright.rawValue - grade
//        let newEasinessFactor = flashcard.easinessFactor + (0.1 - qualityFactor * (0.08 + qualityFactor * 0.02))
//        if newEasinessFactor < easinessFactor {
//            flashcard.easinessFactor = easinessFactor
//        } else {
//            flashcard.easinessFactor = newEasinessFactor
//        }
//        flashcard.repetition += 1
//        switch flashcard.repetition {
//            case 1:
//                flashcard.interval = 1
//            case 2:
//                flashcard.interval = 6
//            default:
//                let newInterval = ceil(Double(flashcard.repetition - 1) * flashcard.easinessFactor)
//                flashcard.interval = Int32(newInterval)
//        }
//        if cardGrade == 3 {
//            flashcard.interval = 0
//        }
//        let seconds = 60
//        let minutes = 60
//        let hours = 24
//        let dayMultiplier = seconds * minutes * hours
//        let extraDays = dayMultiplier * flashcard.interval
//        let newNexDatetime = currentDatetime + Double(extraDays)
//        flashcard.previousDate = flashcard.nextDate
//        flashcard.nextDate = newNexDatetime
//        return flashcard
//        
//        }
//    }
//}
