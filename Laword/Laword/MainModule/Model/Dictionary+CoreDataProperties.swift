//
//  Dictionary+CoreDataProperties.swift
//  Laword
//
//  Created by Ildar Khabibullin on 16.10.2022.
//
//

import Foundation
import CoreData


extension Dictionary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dictionary> {
        return NSFetchRequest<Dictionary>(entityName: "Dictionary")
    }

    @NSManaged public var countAllWords: Int16
    @NSManaged public var countDontKnowWords: Int16
    @NSManaged public var countEasyWords: Int16
    @NSManaged public var countHardWords: Int16
    @NSManaged public var countNewWords: Int16
    @NSManaged public var name: String?
    @NSManaged public var pic: Data?
    @NSManaged public var word: NSSet?

}

// MARK: Generated accessors for word
extension Dictionary {

    @objc(addWordObject:)
    @NSManaged public func addToWord(_ value: Word)

    @objc(removeWordObject:)
    @NSManaged public func removeFromWord(_ value: Word)

    @objc(addWord:)
    @NSManaged public func addToWord(_ values: NSSet)

    @objc(removeWord:)
    @NSManaged public func removeFromWord(_ values: NSSet)

}

extension Dictionary : Identifiable {

}
