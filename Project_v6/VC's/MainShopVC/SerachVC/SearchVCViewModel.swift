//
//  SearchVCViewModel.swift
//  Project_v6
//
//  Created by Константин Вороненко on 20.02.22.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchVCViewModelProtocol {
    var productName: String { get set }
    var foundProducts: PublishSubject<[Product]> { get set }
    
    func searchForProducts(productName: String)
}

final class SearchVCViewModel: SearchVCViewModelProtocol {
    var foundProducts = PublishSubject<[Product]>()
    
    var productName: String = ""
    
    func searchForProducts(productName: String) {
        if !productName.isEmpty {
            ProductsNetworkService().getProductsByName(name: productName) { products in
                self.foundProducts.onNext(products)
            }
        }
    }
}

