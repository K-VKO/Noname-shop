//
//  ArticleVC.swift
//  Project_v6
//
//  Created by Константин Вороненко on 25.02.22.
//

import UIKit
import RxSwift
import RxCocoa

final class ArticleVC: UIViewController {
    var viewModel: ArticleVCViewModelProtocol = ArticleVCViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView
                .rx.setDelegate(self)
                .disposed(by: disposeBag)
            
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 400
            
            tableView.register(UINib(nibName: "ArticleVCCell", bundle: nil), forCellReuseIdentifier: "ArticleVCCell")
        }
    }
    
    private func configureTable() {
        viewModel.articlePS.bind(
            to: tableView.rx.items(
            cellIdentifier: "ArticleVCCell",
            cellType: ArticleVCCell.self)) { row, item, cell in
                cell.setup(article: item)
            }.disposed(by: disposeBag)
        
        viewModel.articlePS.onNext([viewModel.article])
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
    }
}

extension ArticleVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
     }
}
