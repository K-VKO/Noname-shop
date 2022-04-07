//
//  UIImageView+LoadFromURL.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 13.02.22.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    
}
extension UIImage {
    
}
