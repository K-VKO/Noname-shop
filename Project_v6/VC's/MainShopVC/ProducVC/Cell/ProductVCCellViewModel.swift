//
//  ProductVCCellViewModel.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 16.02.22.
//

import Foundation
import UIKit

protocol ProductVCCellViewModelProtocol {
    var images: [URL] { get set }
    var localImages: [String] { get set }
    var product: Product { get set }
    var delegate: ProductVCCellViewModelDelegate? { get set }
    
    var imagesDidSet: (() -> Void)? { get set }
    
    func addToCartDidTap()
}

protocol ProductVCCellViewModelDelegate {
    func hideView()
}

final class ProductVCCellViewModel: ProductVCCellViewModelProtocol {
    var delegate: ProductVCCellViewModelDelegate?
    
    func addToCartDidTap() {
        //TODO: add product to shopping cart and save
        CoreDataService.getShoppingCartFromDB { [weak self] grabbedCart in
            var shoppingCart = grabbedCart
            
            let productDB = ProductDB(context: CoreDataService.managedObjectContext)
            productDB.title = self?.product.title
            productDB.price = self?.product.price.current_price ?? 0.0
            productDB.asin = self?.product.asin
            
            
            if shoppingCart == nil {
                shoppingCart = ShoppingCart(context: CoreDataService.managedObjectContext)
                shoppingCart?.addToProducts(productDB)
            } else {
                grabbedCart?.addToProducts(productDB)
            }
        }
        
        CoreDataService.saveContext()
        
        delegate?.hideView()
    }
    
    var product = Product()
    
    var imagesDidSet: (() -> Void)?
    
    var localImages: [String] = [] {
        didSet {
            imagesDidSet?()
        }
    }
    
    var images: [URL] = [] {
        didSet {
                imagesDidSet?()
            }
     }
}
