//
//  SliderViewCell.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 10.02.22.
//

import UIKit

class SliderViewCell: UICollectionViewCell {

    @IBOutlet weak var sliderImage: UIImageView!
    
    func setup(image: UIImage?) {
        self.sliderImage.image = image
    }

}
