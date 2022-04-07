//
//  ProductDB+CoreDataClass.swift
//  Project_v6
//
//  Created by Константин Вороненко on 23.02.22.
//
//

import Foundation
import CoreData

@objc(ProductDB)
public class ProductDB: NSManagedObject {
    func toProduct(productDB: ProductDB) -> Product {
        var product = Product()
        if let title = productDB.title,
           let asin = productDB.asin {
            product.title = title
            product.asin = asin
        }
        product.price = Price(current_price: productDB.price)
        return product
    }
}
