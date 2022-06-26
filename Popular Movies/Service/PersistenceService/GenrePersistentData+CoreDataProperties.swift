//
//  GenrePersistentData+CoreDataProperties.swift
//  Popular Movies
//
//  Created by Никита Дубовик on 24.01.2022.
//
//

import Foundation
import CoreData


extension GenrePersistentData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GenrePersistentData> {
        return NSFetchRequest<GenrePersistentData>(entityName: "GenrePersistentData")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}

extension GenrePersistentData : Identifiable {

}
