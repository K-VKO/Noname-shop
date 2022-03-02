//
//  Product.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 10.02.22.
//

import Foundation
import UIKit

struct Response: Decodable {
    var result: [Product]
}

struct ProductDetailsResult: Decodable {
    var result: [ProductDetails]?
}

struct Product: Decodable {
    var title: String
    var price: Price
    var thumbnail: URL
    var asin: String
    
    var details: ProductDetails?
    var mainImageName: String?
    
    init() {
        self.title = ""
        self.price = Price(current_price: 0.0)
        self.thumbnail = URL(fileURLWithPath: "")
        self.asin = ""
    }
}

struct Price: Decodable {
    var current_price: Double
}

struct ProductDetails: Decodable {
    var description: String?
    var images: [URL] = []
    
    var localImages: [String]?
    
    init() {}
    
    init(description: String, images: [URL]) {
        self.description = description
        self.images = images
    }
    
    init(description: String, localImages: [String]) {
        self.description = description
        self.localImages = localImages
    }
}
