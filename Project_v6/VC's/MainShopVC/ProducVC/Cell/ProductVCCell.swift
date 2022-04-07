//
//  ProductVCCell.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 16.02.22.
//

import UIKit
import Lottie
final class ProductVCCell: UITableViewCell {
    var viewModel: ProductVCCellViewModelProtocol = ProductVCCellViewModel()

    @IBOutlet weak var preloader: AnimationView! {
        didSet {
            preloader.loopMode = .loop
            preloader.contentMode = .scaleAspectFit
            preloader.play()
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imagesCollection: UICollectionView! {
        didSet {
            imagesCollection.delegate = self
            imagesCollection.dataSource = self
            
            imagesCollection.register(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        }
    }
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    @IBOutlet weak var addToCartButton: UIButton! {
        didSet {
            addToCartButton.layer.cornerRadius = 10
        }
    }
    
    @IBAction func addToCartDidtap() {
        viewModel.addToCartDidTap()
    }
    
    @IBOutlet weak var addToFavoritesButton: UIButton!  {
        didSet {
            addToFavoritesButton.layer.cornerRadius = 15
        }
    }
    
    private func bind() {
        viewModel.imagesDidSet = {
            self.imagesCollection.reloadData()
            self.preloader.stop()
            self.preloader.isHidden = true
        }
    }
    
    func setup(product: Product) {
        if let localImages = product.details?.localImages {
            self.viewModel.localImages = localImages
            self.pageControl.numberOfPages = localImages.count
        } else if let images = product.details?.images {
            self.viewModel.images = images
            self.pageControl.numberOfPages = images.count
        }
        
        self.title.text = product.title
        self.price.text = "$\(product.price.current_price)"
        self.productDescription.text = product.details?.description
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bind()
    }
    
}

extension ProductVCCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.localImages.isEmpty {
            return viewModel.images.count
        } else {
            return viewModel.localImages.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        if !self.viewModel.localImages.isEmpty {
            cell.setup(localImageName: self.viewModel.localImages[indexPath.row])
        } else {
            cell.setup(imageURL: self.viewModel.images[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    //Page Control
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         let pageWidth = self.imagesCollection.frame.size.width
         pageControl.currentPage = Int(self.imagesCollection.contentOffset.x / pageWidth)
   }
}

