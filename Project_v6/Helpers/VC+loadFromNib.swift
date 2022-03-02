//
//  File.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 9.02.22.
//
import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
}
