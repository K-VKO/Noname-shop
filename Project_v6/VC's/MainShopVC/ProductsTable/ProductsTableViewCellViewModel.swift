//
//  ProductsTableViewCellViewModel.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 12.02.22.
//

import Foundation

protocol ProductsTableViewCellViewModelProtocol {
    var productsToInitalize: [Product] { get set }
    var productsDidChange: (() -> Void)? { get set }
}

final class ProductsTableViewCellViewModel: ProductsTableViewCellViewModelProtocol {
    var productsToInitalize: [Product] = [] {
        didSet {
            productsDidChange?()
        }
    }
    
    var productsDidChange: (() -> Void)?
}
