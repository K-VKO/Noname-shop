//
//  ProductsCollectionViewCell.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 12.02.22.
//

import UIKit

final class ProductsCollectionViewCell: UICollectionViewCell {
    var cornerRadius: CGFloat = 20.0
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func setup(product: Product) {
        self.price.text = "$\(product.price.current_price)"
        self.title.text = product.title
        self.image.load(url: product.thumbnail)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()


        self.contentView.layer.cornerRadius = cornerRadius
        self.contentView.layer.masksToBounds = true
                
                // Set masks to bounds to false to avoid the shadow
                // from being clipped to the corner radius
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
                
                // Apply a shadow
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowPath = UIBezierPath(
                    roundedRect: bounds,
                    cornerRadius: cornerRadius
                ).cgPath
    }
}
