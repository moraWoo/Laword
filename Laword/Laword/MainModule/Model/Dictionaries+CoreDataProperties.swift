//
//  Dictionaries+CoreDataProperties.swift
//  Laword
//
//  Created by Ильдар on 18.09.2022.
//
//

import Foundation
import CoreData


extension Dictionaries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dictionaries> {
        return NSFetchRequest<Dictionaries>(entityName: "Dictionaries")
    }

    @NSManaged public var name: String?
    @NSManaged public var countOfDictionaries: Int16
    @NSManaged public var dictionary: NSSet?

}

// MARK: Generated accessors for dictionary
extension Dictionaries {

    @objc(addDictionaryObject:)
    @NSManaged public func addToDictionary(_ value: Dictionary)

    @objc(removeDictionaryObject:)
    @NSManaged public func removeFromDictionary(_ value: Dictionary)

    @objc(addDictionary:)
    @NSManaged public func addToDictionary(_ values: NSSet)

    @objc(removeDictionary:)
    @NSManaged public func removeFromDictionary(_ values: NSSet)

}

extension Dictionaries : Identifiable {

}
