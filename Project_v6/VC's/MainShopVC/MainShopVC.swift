//
//  MainShopVC.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 9.02.22.
//

import UIKit
import Firebase
import Lottie

final class MainShopVC: UIViewController {
    private var viewModel: MainShopViewModelProtocol = MainShopViewModel()
    
    @IBOutlet weak var preloader: AnimationView! {
        didSet {
            preloader.loopMode = .loop
            preloader.contentMode = .scaleAspectFill
            preloader.play()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var searchResults: UITableView! {
        didSet {
            searchResults.isHidden = true
            searchResults.delegate = self
            searchResults.dataSource = self
            
            searchResults.isAccessibilityElement = true
            searchResults.accessibilityIdentifier = "searchResults"
            
            searchResults.register(UINib(nibName: "SearchResultsCell", bundle: nil), forCellReuseIdentifier: "SearchResultsCell")
        }
    }
    
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint! {
        didSet {
            if UIScreen.main.bounds.height < 700 {
                logoHeightConstraint.constant = 50
            }
        }
    }
    
    @IBOutlet weak var sliderCollection: UICollectionView! {
        didSet {
            sliderCollection.delegate = self
            sliderCollection.dataSource = self
            sliderCollection.register(UINib(nibName: "SliderViewCell", bundle: nil), forCellWithReuseIdentifier: "SliderViewCell")
            
            sliderCollection.layer.cornerRadius = 10
            sliderCollection.layer.masksToBounds = true
            
            //Begin timer for auto sliding
            self.sliderTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.scrollSlider), userInfo: nil, repeats: true)
        }
    }
    @IBOutlet weak var sliderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControlForSlider: UIPageControl!
    
    @IBOutlet weak var productsTable: UITableView! {
        didSet {
            productsTable.dataSource = self
            productsTable.delegate = self
            
            productsTable.isAccessibilityElement = true
            productsTable.accessibilityIdentifier = "productsTable"

            productsTable.register(UINib(nibName: "ProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductsTableViewCell")
        }
    }
    
    
    private var sliderTimer = Timer()
    private var counter = 0
    
    @objc private func scrollSlider() {
        if counter < 3 {
             let index = IndexPath.init(item: counter, section: 0)
             self.sliderCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
             pageControlForSlider.currentPage = counter
             counter += 1
        } else {
             counter = 0
             let index = IndexPath.init(item: counter, section: 0)
             self.sliderCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
              pageControlForSlider.currentPage = counter
              counter = 1
         }
    }
    
    private func bind() {
        viewModel.productsDidChange = {
            DispatchQueue.main.async {
                self.preloader.stop()
                self.preloader.isHidden = true
                self.productsTable.reloadData()
            }
        }
        viewModel.resulsDidChange = {
            self.searchResults.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        self.hideKeyboardWhenTappedAround()
        viewModel.loadProducts()
    }

}

//MARK: Search bar
extension MainShopVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let vc = SearchVC.loadFromNib()
        if let text = searchBar.text {
            vc.viewModel.productName = text
            CoreDataService.saveSearchResult(text: text)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.loadSearchResults()
        if viewModel.searchResults.count > 0 {
            self.searchResults.isHidden = false
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchResults.isHidden = true
    }
}

//MARK: Slider
extension MainShopVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.sliderImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderViewCell", for: indexPath) as! SliderViewCell
        cell.setup(image: self.viewModel.sliderImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}


//MARK: Products table
extension MainShopVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.accessibilityIdentifier == "productsTable" {
            return viewModel.tableSections.count
        } else {
            return viewModel.searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.accessibilityIdentifier == "productsTable" {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableViewCell") as! ProductsTableViewCell
        cell.delegate = self
        cell.viewModel.productsToInitalize = self.viewModel.products.shuffled()
        cell.sectionTitle.text = viewModel.tableSections[indexPath.row].sectionTitle
        if viewModel.products.count > 0 {
            cell.sectionOfProducts.reloadData()
        }
        return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsCell") as! SearchResultsCell
            cell.label.text = viewModel.searchResults.reversed()[indexPath.row].text
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.accessibilityIdentifier == "productsTable" {
            return CGFloat(330)
        } else {
            return CGFloat(40)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.accessibilityIdentifier == "productsTable" {
            if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0 && scrollView.contentOffset.y <= 0  {
                    UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseInOut, animations: {
                        self.sliderHeightConstraint.constant = 100
                        self.pageControlForSlider.alpha = 1
                        self.view.layoutIfNeeded()
                    }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.sliderHeightConstraint.constant = 0
                    self.pageControlForSlider.alpha = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
    }
    }
}

extension MainShopVC: ProductsTableViewCellDelegate {
    func didSelectProduct(product: Product) {
        let vc = ProductVC.loadFromNib()
        vc.viewModel.product = product
        present(vc, animated: true, completion: nil)
    }
}
