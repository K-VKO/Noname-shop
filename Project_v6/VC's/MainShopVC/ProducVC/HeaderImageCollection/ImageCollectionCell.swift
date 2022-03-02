//
//  ImageCollectionCell.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 14.02.22.
//

import UIKit

final class ImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    func setup(imageURL: URL) {
        self.image.load(url: imageURL)
    }
    
    func setup(localImageName: String) {
        FileManagerService().loadImage(localName: localImageName, completion: { image in
            self.image.image = image
        })
    }
}
