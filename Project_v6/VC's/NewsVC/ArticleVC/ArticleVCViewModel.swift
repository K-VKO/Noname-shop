//
//  ArticleVCViewModel.swift
//  Project_v6
//
//  Created by Константин Вороненко on 25.02.22.
//

import Foundation
import RxSwift
import RxCocoa

protocol ArticleVCViewModelProtocol {
    var articlePS: PublishSubject<[Article]> { get set }
    var article: Article { get set }
}

final class ArticleVCViewModel: ArticleVCViewModelProtocol {
    var articlePS = PublishSubject<[Article]>()
    var article = Article()
}
