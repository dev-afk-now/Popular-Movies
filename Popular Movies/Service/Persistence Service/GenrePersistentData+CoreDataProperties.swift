//
//  GenrePersistentData+CoreDataProperties.swift
//  Popular Movies
//
//  Created by devmac on 20.01.2022.
//
//

import Foundation
import CoreData


extension GenrePersistentData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GenrePersistentData> {
        return NSFetchRequest<GenrePersistentData>(entityName: "GenrePersistentData")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int64

}

extension GenrePersistentData : Identifiable {

}
