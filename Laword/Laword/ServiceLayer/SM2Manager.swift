//
//  SM2Manager.swift
//  Laword
//
//  Created by Ildar Khabibullin on 09.10.2022.
//

import Foundation

//public enum Grade: Int {
//    /// complete blackout.
//    case null
//    /// incorrect response; the correct one remembered
//    case bad
//    /// incorrect response; where the correct one seemed easy to recall
//    case fail
//    /// correct response recalled with serious difficulty
//    case pass
//    /// correct response after a hesitation
//    case good
//    /// perfect response
//    case bright
//}
//
//protocol SM2ManagerProtocol {
//    func sm2Algorythm(flashcard: Word, grade: Grade, currentDateTime: TimeInterval)
//}
//
//class SM2Manager: SM2ManagerProtocol {
//    func sm2Algorythm(flashcard: Word, grade: Grade, currentDateTime: TimeInterval) {
//        let maxQuality = 5
//        let easinessFactor = 1.3
//        
//        let cardGrade = grade.rawValue
//        
//        if cardGrade < 3 {
//            flashcard.repetition = 0
//            flashcard.interval = 0
//        } else {
//            let qualityFactor = Double(maxQuality - cardGrade) // CardGrade.bright.rawValue - grade
//            let newEasinessFactor = flashcard.easinessFactor + (0.1 - qualityFactor * (0.08 + qualityFactor * 0.02))
//            if newEasinessFactor < easinessFactor {
//                flashcard.easinessFactor = easinessFactor
//            } else {
//                flashcard.easinessFactor = newEasinessFactor
//            }
//            flashcard.repetition += 1
//            switch flashcard.repetition {
//                case 1:
//                    flashcard.interval = 1
//                case 2:
//                    flashcard.interval = 6
//                default:
//                    let newInterval = ceil(Double(flashcard.repetition - 1) * flashcard.easinessFactor)
//                    flashcard.interval = Int32(newInterval)
//            }
//        }
//        if cardGrade == 3 {
//            flashcard.interval = 0
//        }
//        let seconds = 60
//        let minutes = 60
//        let hours = 24
//        let dayMultiplier = seconds * minutes * hours
//        let extraDays = Int32(dayMultiplier) * flashcard.interval
//        let newNexDatetime = currentDateTime + Double(extraDays)
//        flashcard.previousDate = flashcard.nextDate
//        flashcard.nextDate = Date(timeIntervalSince1970: newNexDatetime)
//    }
//}
