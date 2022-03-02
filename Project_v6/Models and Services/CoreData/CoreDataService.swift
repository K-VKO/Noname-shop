//
//  CoreDataService.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 16.02.22.
//

import Foundation
import CoreData
import UIKit

final class CoreDataService: NSManagedObjectContext {
    
    static var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentCloudKitContainer = {
        
        let container = NSPersistentCloudKitContainer(name: "Project_v6")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataService {
   static func getProductDetailsFromDB(asin: String, completion: @escaping (ProductDetails?) -> Void) {
        let request = ProductDB.fetchRequest()
        if let productDB = try? CoreDataService.managedObjectContext
            .fetch(request)
            .filter({ $0.asin == asin }).first {
            if let localImages = productDB.images?.compactMap({ ($0 as! ImageDB).name }) {
                completion(ProductDetails(description: productDB.productDescription ?? "", localImages: localImages))
            }
        } else {
          completion(nil)
      }
    }
    
    static func getProductFromDB(asin: String, completion: @escaping (Product?) -> Void) {
         let request = ProductDB.fetchRequest()
         if let productDB = try? CoreDataService.managedObjectContext
             .fetch(request)
             .filter({ $0.asin == asin }).first {
             completion(productDB.toProduct(productDB: productDB))
         } else {
           completion(nil)
       }
     }
    
    static func getShoppingCartFromDB(completion: @escaping (ShoppingCart?) -> Void) {
        let request = ShoppingCart.fetchRequest()
        request.fetchLimit = 1
        
        let cart = try? managedObjectContext.fetch(request).first
        if let cart = cart {
            completion(cart)
            print("found shopping cart with products: \(cart.products)")
        } else {
            completion(nil)
        }
    }
    
    static func saveProductToDB(product: Product, details: ProductDetails) {
        let productDB = ProductDB(context: CoreDataService.managedObjectContext)
        productDB.title = product.title
        productDB.asin = product.asin
        productDB.price = product.price.current_price
        
        productDB.productDescription = details.description
        details.images.enumerated().forEach { (index, imageURL) in
            
            DispatchQueue(label: "saveImageQueue", qos: .background).async {
                if let data = try? Data( contentsOf: imageURL ),
                   let image = UIImage(data: data) {
                    
                    FileManagerService().save(image: image, name: "\(product.asin)\(index)") { imageName in
                        if imageName != nil {
                            let imageDB = ImageDB(context: CoreDataService.managedObjectContext)
                            imageDB.name = imageName
                            productDB.addToImages(imageDB)
                        }
                    }
                    
                }
            }
            
        }
        CoreDataService.saveContext()
     }
    
    static func saveProductToDB(product: Product) {
        let productDB = ProductDB(context: CoreDataService.managedObjectContext)
        productDB.title = product.title
        productDB.asin = product.asin
        
        if let data = try? Data(contentsOf: product.thumbnail),
           let image = UIImage(data: data) {
            FileManagerService().save(image: image, name: "\(product.asin)MI") { imageName in
                productDB.mainImage = imageName
            }
        }
        productDB.price = product.price.current_price
        CoreDataService.saveContext()
     }
    
    static func saveProductsToDB(products: [Product], completion: @escaping () -> Void) {
        products.forEach { product in
            DispatchQueue(label: "savingProductsQueue", qos: .background).async {
                let productDB = ProductDB(context: CoreDataService.managedObjectContext)
                productDB.title = product.title
                productDB.asin = product.asin
                
                if let data = try? Data(contentsOf: product.thumbnail),
                   let image = UIImage(data: data) {
                    FileManagerService().save(image: image, name: "\(product.asin)MI") { imageName in
                        productDB.mainImage = imageName
                    }
                }
                productDB.price = product.price.current_price
                CoreDataService.saveContext()
                
                completion()
            }
        }

     }
    
    static func saveSearchResult(text: String) {
        let searchResult = SearchResult(context: CoreDataService.managedObjectContext)
        searchResult.text = text
        CoreDataService.saveContext()
    }
    
    static func loadSearchResults(completion: @escaping (([SearchResult]?) -> Void)) {
            let request = SearchResult.fetchRequest()
            
            let results = try? managedObjectContext.fetch(request)
            if let results = results {
                completion(results)
            } else {
                completion(nil)
            }
    }
}


