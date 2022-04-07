//
//  ArticleVCCell.swift
//  Project_v6
//
//  Created by Константин Вороненко on 25.02.22.
//

import UIKit

final class ArticleVCCell: UITableViewCell {
    @IBOutlet weak var mainImage: DownloadImageView!
    @IBOutlet weak var articleText: UILabel!
    
    func setup(article: Article) {
        self.articleText.text = article.description
        if let image = ImageCacheService.shared.load(productId: "\(article.title)".transformToId()) {
            print("found cache")
            mainImage.image = image
        } else {
            print("loading from url")
            mainImage.load(URL(string: article.urlToImage)) { image in
                ImageCacheService.shared.save(productId: "\(article.title)".transformToId(), image: image)
            }
        }
    }
}
