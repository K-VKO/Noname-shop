//
//  ProductVC.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 16.02.22.
//

import UIKit

final class ProductVC: UIViewController {
    var viewModel: ProductVCViewModelProtocol = ProductVCViewModel()
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(ProductVCCell.self)
            tableView.register(UINib(nibName: "ProductVCCell", bundle: nil), forCellReuseIdentifier: "ProductVCCell")
        }
    }
    
    private func bind() {
        viewModel.detailsDidChange = {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.loadDetails()
    }
}

extension ProductVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1  //One cell for whole screen
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductVCCell") as! ProductVCCell
        if let product = self.viewModel.product {
            cell.viewModel.product = product
            cell.setup(product: product)
        }
        cell.viewModel.delegate = self
        return cell
    }
}

extension ProductVC: ProductVCCellViewModelDelegate {
    func hideView() {
        dismiss(animated: true, completion: nil)
    }
}
