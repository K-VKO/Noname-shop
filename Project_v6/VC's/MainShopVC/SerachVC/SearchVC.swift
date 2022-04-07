//
//  SearchVC.swift
//  Project_v6
//
//  Created by Константин Вороненко on 20.02.22.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchVC: UIViewController {
    var viewModel: SearchVCViewModelProtocol = SearchVCViewModel()
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView
                .rx.setDelegate(self)
                .disposed(by: disposeBag)
            
            tableView.rx.modelSelected(Product.self)
                        .subscribe(onNext: { [weak self] model in
                            let vc = ProductVC.loadFromNib()
                            vc.viewModel.product = model
                            self?.present(vc, animated: true, completion: nil)
                        }).disposed(by: disposeBag)

            
            tableView.register(UINib(nibName: "SerachCell", bundle: nil), forCellReuseIdentifier: "SerachCell")
        }
    }
    
    private func congifureTable() {
        viewModel.foundProducts.bind(
            to: tableView.rx.items(
            cellIdentifier: "SerachCell",
            cellType: SerachCell.self)) { row, item, cell in
                cell.setup(product: item)
            }.disposed(by: disposeBag)
        
        viewModel.searchForProducts(productName: self.viewModel.productName)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        congifureTable()
    }
}

extension SearchVC: UIScrollViewDelegate, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(300.0)
    }
}
