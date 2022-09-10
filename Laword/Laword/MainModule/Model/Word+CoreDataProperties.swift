//
//  Word+CoreDataProperties.swift
//  Laword
//
//  Created by Ildar Khabibullin on 10.09.2022.
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
    @NSManaged public var wordTranslation: String?
    @NSManaged public var wordShowed: NSNumber?

}

extension Word : Identifiable {

}
