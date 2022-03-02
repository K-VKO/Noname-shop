//
//  MainShopViewModel.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 10.02.22.
//

import Foundation
import UIKit

protocol MainShopViewModelProtocol {
    var sliderImages: [UIImage] { get }
    var products: [Product] { get }
    var searchResults: [SearchResult] { get set }
    var productsDidChange: (() -> Void)? { get set }
    var resulsDidChange: (() -> Void)? { get set }
    
    var tableSections: [(sectionTitle: String,
                         products: [Product]?)] { get }
    
    func loadProducts()
    func loadSearchResults()
}


final class MainShopViewModel: MainShopViewModelProtocol {
    var resulsDidChange: (() -> Void)?
    
    var searchResults: [SearchResult] = [] {
        didSet {
            resulsDidChange?()
        }
    }
    
    func loadSearchResults() {
        CoreDataService.loadSearchResults { grabbedResults in
            if let grabbedResults = grabbedResults {
                self.searchResults = grabbedResults
            }
        }
    }
    
    func loadProducts() {
        ProductsNetworkService().getProducts { [weak self] products in
            if let products = products {
                self?.products = products
            } else {
                //MARK: If no internet load products locally
                ProductsNetworkService().getProductsLocally { [weak self]  products in
                    if let products = products {
                        self?.products = products
                    }
                }
            }
        }
    }
    
    var sliderImages: [UIImage] = []
    var products: [Product] = [] {
        didSet {
            productsDidChange?()
        }
    }
    var productsDidChange: (() -> Void)?
    
    typealias tableSection = (sectionTitle: String,
                               products: [Product]?)
    
    var tableSections: [tableSection] = [
                                         (sectionTitle: "Best selling", products: nil),
                                         (sectionTitle: "Exclusive offers", products: nil),
                                         (sectionTitle: "New tech", products: nil)
    ]
    
    init() {
        for i in 1...3 {
            self.sliderImages.append(UIImage(named: "banner\(i)")!)
        }
    }
}
