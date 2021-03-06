//
//  MoviePersistentData+CoreDataProperties.swift
//  Popular Movies
//
//  Created by Никита Дубовик on 24.01.2022.
//
//

import Foundation
import CoreData


extension MoviePersistentData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviePersistentData> {
        return NSFetchRequest<MoviePersistentData>(entityName: "MoviePersistentData")
    }

    @NSManaged public var genres: [Int]?
    @NSManaged public var id: Int64
    @NSManaged public var imageURL: String?
    @NSManaged public var rating: Double
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?

}

extension MoviePersistentData : Identifiable {

}
