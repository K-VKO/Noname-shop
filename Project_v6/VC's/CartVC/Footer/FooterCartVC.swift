//
//  FooterCartVC.swift
//  Project_v6
//
//  Created by Константин Вороненко on 24.02.22.
//

import UIKit

final class FooterCartVC: UITableViewHeaderFooterView {
    @IBOutlet weak var totalAmount: UILabel!
    
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.layer.cornerRadius = 15
        }
    }
}
