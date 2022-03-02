//
//  CartVCCell.swift
//  Project_v6
//
//  Created by Константин Вороненко on 21.02.22.
//

import UIKit

final class CartVCCell: UITableViewCell {
    var viewModel: CartVCCellViewModelProtocol = CartVCCellViewModel()
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var removeButton: UIButton! {
        didSet {
            removeButton.layer.cornerRadius = 5
        }
    }
    @IBAction func removeDidTap() {
        CoreDataService.getShoppingCartFromDB {[weak self] grabbedCart in
            if let grabbedCart = grabbedCart, let product = self?.viewModel.product {
                grabbedCart.removeFromProducts(product)
                CoreDataService.saveContext()
            } else {
                fatalError("error removing from cart")
            }
        }
    }
    
    func setup(product: ProductDB) {
        self.title.text = product.title
        self.price.text = "$\(product.price)"
        if let asin = product.asin {
            FileManagerService().loadImage(localName: "\(asin)0.jpg", completion: { image in
                DispatchQueue.main.async {
                    self.mainImage.image = image
                }
            })
        }
        viewModel.product = product
    }
}
