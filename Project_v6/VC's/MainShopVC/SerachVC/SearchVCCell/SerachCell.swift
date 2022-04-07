//
//  SerachVCCell.swift
//  Project_v6
//
//  Created by Константин Вороненко on 20.02.22.
//

import UIKit

final class SerachCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    func setup(product: Product) {
        self.title.text = product.title
        self.price.text = "$\(product.price.current_price)"
        self.mainImage.load(url: product.thumbnail )
    }
}
