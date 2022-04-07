//
//  CartVC.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 15.02.22.
//

import UIKit
import Lottie
import CoreData
import RxSwift
import RxCocoa

final class CartVC: UIViewController {
    var viewModel: CartVCViewModelProtocol = CartVCViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var preloader: AnimationView! {
        didSet {
            preloader.loopMode = .loop
            preloader.contentMode = .scaleAspectFit
            preloader.play()
            
            viewModel.productsInCart.subscribe {[weak self] event in
                if let count = event.element?.count {
                    if count == 0 {
                        self?.preloader.isHidden = false
                    } else {
                        self?.preloader.isHidden = true
                    }
                }
            }.disposed(by: disposeBag)
    }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView
                .rx.setDelegate(self)
                .disposed(by: disposeBag)
            
            viewModel.productsInCart.bind(
                to: tableView.rx.items(
                    cellIdentifier: "CartVCCell",
                    cellType: CartVCCell.self)) { row, item, cell in
                        cell.setup(product: item)
                    }.disposed(by: disposeBag)
            
            tableView.register(UINib(nibName: "CartVCCell", bundle: nil), forCellReuseIdentifier: "CartVCCell")
            
            tableView.register(UINib(nibName: "FooterCartVC", bundle: nil), forHeaderFooterViewReuseIdentifier: "FooterCartVC")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getShoppingCartFromDB()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        preloader.play()
    }
    
    
    
}

extension CartVC: UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(178.0)
    }
}

extension CartVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView.numberOfRows(inSection: 0) == 0 {
            return nil
        } else {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FooterCartVC") as! FooterCartVC
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(120.0)
    }
}
