//
//  ProductDB+CoreDataProperties.swift
//  Project_v6
//
//  Created by Константин Вороненко on 23.02.22.
//
//

import Foundation
import CoreData


extension ProductDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductDB> {
        return NSFetchRequest<ProductDB>(entityName: "ProductDB")
    }

    @NSManaged public var asin: String?
    @NSManaged public var mainImage: String?
    @NSManaged public var price: Double
    @NSManaged public var productDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var images: NSSet?
    @NSManaged public var shoppingCart: ShoppingCart?

}

// MARK: Generated accessors for images
extension ProductDB {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ImageDB)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ImageDB)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

extension ProductDB : Identifiable {

}
