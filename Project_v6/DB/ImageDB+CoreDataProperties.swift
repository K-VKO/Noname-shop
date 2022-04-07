//
//  ImageDB+CoreDataProperties.swift
//  Project_v6
//
//  Created by Константин Вороненко on 23.02.22.
//
//

import Foundation
import CoreData


extension ImageDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageDB> {
        return NSFetchRequest<ImageDB>(entityName: "ImageDB")
    }

    @NSManaged public var name: String?
    @NSManaged public var product: ProductDB?

}

extension ImageDB : Identifiable {

}
