//
//  CartVCCellViewModel.swift
//  Project_v6
//
//  Created by Константин Вороненко on 23.02.22.
//

import Foundation

protocol CartVCCellViewModelProtocol {
    var product: ProductDB { get set }
}

final class CartVCCellViewModel: CartVCCellViewModelProtocol {
    var product = ProductDB()
}
