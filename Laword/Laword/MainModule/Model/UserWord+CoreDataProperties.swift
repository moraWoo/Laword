//
//  UserWord+CoreDataProperties.swift
//  Laword
//
//  Created by Ildar Khabibullin on 11.09.2022.
//
//

import Foundation
import CoreData


extension UserWord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserWord> {
        return NSFetchRequest<UserWord>(entityName: "UserWord")
    }

    @NSManaged public var uword: String?
    @NSManaged public var uwordKey: String?
    @NSManaged public var uwordShowed: Bool
    @NSManaged public var uwordTranslation: String?

}

extension UserWord : Identifiable {

}
