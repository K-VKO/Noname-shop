//
//  ProductsTableViewCell.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 11.02.22.
//

import UIKit

protocol ProductsTableViewCellDelegate {
    func didSelectProduct(product: Product)
}

class ProductsTableViewCell: UITableViewCell {
    var viewModel: ProductsTableViewCellViewModelProtocol = ProductsTableViewCellViewModel()
    
    var delegate: ProductsTableViewCellDelegate?
    
    @IBOutlet weak var sectionTitle: UILabel!
    
    @IBOutlet weak var sectionOfProducts: UICollectionView! {
        didSet {
            sectionOfProducts.delegate = self
            sectionOfProducts.dataSource = self
            
            sectionOfProducts.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        }
    }
    
    func bind() {
        viewModel.productsDidChange = {
            self.sectionOfProducts.reloadData()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel.productsToInitalize = []
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bind()
    }
    
}

extension ProductsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.productsToInitalize.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        cell.setup(product: viewModel.productsToInitalize[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectProduct(product: viewModel.productsToInitalize[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
}
