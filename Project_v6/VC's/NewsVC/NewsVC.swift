//
//  FavoritesVC.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 15.02.22.
//

import UIKit
import Lottie
import RxCocoa
import RxSwift

final class NewsVC: UIViewController {
    var viewModel: NewsVCViewModelProtocol = NewsVCViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var preloader: AnimationView! {
        didSet {
            preloader.loopMode = .loop
            preloader.contentMode = .scaleAspectFit
            preloader.play()
            
            viewModel.news.subscribe { [weak self] event in
                self?.preloader.isHidden = true
            }.disposed(by: disposeBag)
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 400
            

            tableView.register(UINib(nibName: "NewsVCCell", bundle: nil), forCellReuseIdentifier: "NewsVCCell")
        }
    }

    
    private func configureTable() {
        tableView.rx.modelSelected(Article.self)
                    .subscribe(onNext: { [weak self] model in
                        let vc = ArticleVC.loadFromNib()
                        vc.viewModel.article = model
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }).disposed(by: disposeBag)

        
        viewModel.news.bind(
            to: tableView.rx.items(
            cellIdentifier: "NewsVCCell",
            cellType: NewsVCCell.self)) { row, item, cell in
                cell.setup(article: item)
            }.disposed(by: disposeBag)
        
        viewModel.getNews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
    }
}
