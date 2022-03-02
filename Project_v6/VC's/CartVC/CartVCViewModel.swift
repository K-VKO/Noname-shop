//
//  CartVCViewModel.swift
//  Project_v6
//
//  Created by Константин Вороненко on 22.02.22.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

protocol CartVCViewModelProtocol {
    var productsInCart: PublishSubject<[ProductDB]> { get set }
    
    func getShoppingCartFromDB()
}

class CartVCViewModel: NSObject, CartVCViewModelProtocol {
    var fetchedResultsController: NSFetchedResultsController<ProductDB>!
    var productsInCart = PublishSubject<[ProductDB]>()
    
    
    func getShoppingCartFromDB() {
        if fetchedResultsController == nil {
            let request = NSFetchRequest<ProductDB>(entityName: "ProductDB")
            let sort = NSSortDescriptor(key: "shoppingCart", ascending: false)
            request.sortDescriptors = [sort]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataService.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
            if let products = fetchedResultsController.fetchedObjects?.filter({ $0.shoppingCart != nil }) {
                productsInCart.onNext(products)
            }
        } catch {
            print("failed fetch")
        }
}
}

extension CartVCViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let products = fetchedResultsController.fetchedObjects?.filter({ $0.shoppingCart != nil }) {
          productsInCart.onNext(products)
         }
        switch type {
        case .insert:
            print("insert")
//            if let products = fetchedResultsController.fetchedObjects?.filter({ $0.shoppingCart != nil }) {
//                productsInCart.onNext(products)
//            }
        case .delete:
            print("DELETING")
        case .move:
            print("MOVE")
//            if let fetchedProducts = fetchedResultsController.fetchedObjects?.filter({ $0.shoppingCart != nil }) {
//                productsInCart.onNext(fetchedProducts)
//            }
        case .update:
            print("UPDATE")
//            if let fetchedProducts = fetchedResultsController.fetchedObjects?.filter({ $0.shoppingCart != nil }) {
//                productsInCart.onNext(fetchedProducts)
//            }
        @unknown default:
            fatalError()
        }
    }
}

