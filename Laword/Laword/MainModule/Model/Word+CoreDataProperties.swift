//
//  Word+CoreDataProperties.swift
//  Laword
//
//  Created by Ildar Khabibullin on 09.10.2022.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var word: String?
    @NSManaged public var wordKey: String?
    @NSManaged public var wordShowed: NSNumber?
    @NSManaged public var wordShowedNow: String?
    @NSManaged public var wordTranslation: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var repetition: Int32
    @NSManaged public var interval: Int32
    @NSManaged public var easinessFactor: Double
    @NSManaged public var previousDate: Date?
    @NSManaged public var nextDate: Date?
    @NSManaged public var dictionary: Dictionary?

}

extension Word : Identifiable {

}
