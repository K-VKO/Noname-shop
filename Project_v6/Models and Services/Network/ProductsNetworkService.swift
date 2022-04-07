//
//  ProductsNetworkService.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 10.02.22.
//

import Foundation

final class ProductsNetworkService {
    private let key = "6e2962f8ccmshc9126413e39d9dap159bb5jsn711ad596c1c5"
    
    func getProducts(completion: @escaping ([Product]?) -> Void) {
        let headers = [
            "x-rapidapi-host": "amazon23.p.rapidapi.com",
            "x-rapidapi-key": key
        ]
        
        
        guard let url = URL(string: "https://amazon23.p.rapidapi.com/product-search?query=samsung&country=US") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { responseData, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = responseData {
                let products = try? JSONDecoder().decode(Response.self, from: data).result
                if let products = products {
                    DispatchQueue.main.async {
                        completion(products)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }.resume()
    }
    
    func getProductsLocally(completion: @escaping (([Product]?) -> Void) ) {
        if let bundlePath = Bundle.main.path(forResource: "response",
                                             ofType: "json"),
           let jsonData = try? String(contentsOfFile: bundlePath).data(using: .utf8),
           let products = try? JSONDecoder().decode(Response.self, from: jsonData).result {
            DispatchQueue.main.async {
                completion(products)
            }
        } else {
            completion(nil)
        }
    }
    
    func getProductsByName(name: String, completion: @escaping ([Product]) -> Void) {
        let headers = [
            "x-rapidapi-host": "amazon23.p.rapidapi.com",
            "x-rapidapi-key": key
        ]
        
        
        guard let url = URL(string: "https://amazon23.p.rapidapi.com/product-search?query=\(name)&country=US") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { responseData, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = responseData {
                let products = try? JSONDecoder().decode(Response.self, from: data).result
                DispatchQueue.main.async {
                    completion(products ?? [Product]())
                }
            }
        }.resume()
    }
    func getProductDetails(asin: String, completion: @escaping (ProductDetails) -> Void) {
        let headers = [
            "x-rapidapi-host": "amazon23.p.rapidapi.com",
            "x-rapidapi-key": key
        ]
        
        
        guard let url = URL(string: "https://amazon23.p.rapidapi.com/product-details?asin=\(asin)&country=US") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { responseData, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = responseData {
                let productDetails = try? JSONDecoder().decode(ProductDetailsResult.self, from: data)
                DispatchQueue.main.async {
                    completion(productDetails?.result?[0] ?? ProductDetails())
                }
            }
        }.resume()
    }
}
