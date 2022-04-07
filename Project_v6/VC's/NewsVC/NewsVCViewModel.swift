//
//  NewsVCViewModel.swift
//  Project_v6
//
//  Created by Константин Вороненко on 24.02.22.
//
import RxSwift
import RxCocoa
import UIKit

protocol NewsVCViewModelProtocol {
    var news: PublishSubject<[Article]> { get set }
    
    func getNews()
}

final class NewsVCViewModel: NewsVCViewModelProtocol {
    var news = PublishSubject<[Article]>()
    
    func getNews() {
        NewsNetworkService().getNews { grabbedNews in
            if let news = grabbedNews {
                self.news.onNext(news)
            }
        }
    }
}
