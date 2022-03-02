//
//  ProductVCViewModel.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 16.02.22.
//

import Foundation
import UIKit
import CoreData

protocol ProductVCViewModelProtocol {
    var product: Product? { get set }
    
    var detailsDidChange: (() -> Void)? { get set }
    
    func loadDetails()
}

final class ProductVCViewModel: ProductVCViewModelProtocol {
    var product: Product? {
        didSet {
            if self.product?.details?.images.count ?? 0 > 0 || self.product?.details?.localImages?.count ?? 0 > 0 {
                detailsDidChange?()
            }
        }
    }
    
    var detailsDidChange: (() -> Void)?
    
    func loadDetails() {
        if let asin = self.product?.asin {
            
            //MARK: Try to load product from DB
            CoreDataService.getProductDetailsFromDB(asin: asin) { [weak self] details in
                if details != nil {
                    self?.product?.details = details
                } else {
                    //MARK: Else try to load from Network and save to DB
                    ProductsNetworkService().getProductDetails(asin: asin) { [weak self] grabbedDetails in
                        self?.product?.details = ProductDetails(description: grabbedDetails.description ?? "", images: grabbedDetails.images)
                        
                        //MARK: Save product to DB
                        if let product = self?.product,
                           let details = product.details{
                            if details.images.count > 0 || details.localImages?.count ?? 0 > 0 {
                                CoreDataService.saveProductToDB(product: product, details: details)
                            }
                        }
                    }
                }
            }
            
        }
    }
}

