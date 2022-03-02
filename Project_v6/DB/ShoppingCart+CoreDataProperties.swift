//
//  ShoppingCart+CoreDataProperties.swift
//  Project_v6
//
//  Created by Константин Вороненко on 23.02.22.
//
//

import Foundation
import CoreData


extension ShoppingCart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingCart> {
        return NSFetchRequest<ShoppingCart>(entityName: "ShoppingCart")
    }

    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension ShoppingCart {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: ProductDB)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: ProductDB)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}

extension ShoppingCart : Identifiable {

}
