//
//  News.swift
//  Project_v6
//
//  Created by Константин Вороненко on 24.02.22.
//

import Foundation

struct ArticleResults: Decodable {
    var articles: [Article]
}

struct Article: Decodable {
    var title: String
    var description: String
    var urlToImage: String
    var content: String
    
    init() {
        self.title = ""
        self.description = ""
        self.urlToImage = ""
        self.content = "''"
    }
}
