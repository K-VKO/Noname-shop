//
//  ImageCacheService.swift
//  Project_v6
//
//  Created by Константин Вороненко on 2.03.22.
//

import UIKit

final class ImageCacheService {
    static let shared = ImageCacheService()
    
    private let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 50
        cache.totalCostLimit = 100 * 1024 * 1024
        return cache
    }()
    
    func save(productId: String, image: UIImage?) {
        guard let image = image else { return }
        cache.setObject(image, forKey: productId as NSString)
    }
    
    func load(productId: String) -> UIImage? {
        return cache.object(forKey: productId as NSString)
    }
}
