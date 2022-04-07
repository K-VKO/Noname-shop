//
//  NewsVCCell.swift
//  Project_v6
//
//  Created by Константин Вороненко on 24.02.22.
//

import UIKit

final class NewsVCCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var headerImage: DownloadImageView!
    
    func setup(article: Article) {
        self.title.text = article.title
        if let image = ImageCacheService.shared.load(productId: "\(article.title)".transformToId()) {
            print("found cache")
            headerImage.image = image
        } else {
            print("loading from url")
            headerImage.load(URL(string: article.urlToImage)) { image in
                ImageCacheService.shared.save(productId: "\(article.title)".transformToId(), image: image)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerImage.cancel()
        headerImage.image = nil
    }
}
