//
//  String+id.swift
//  Project_v6
//
//  Created by Константин Вороненко on 25.02.22.
//

import Foundation

extension String {
    func transformToId() -> String {
        return "\(self.suffix(1))\(self.prefix(2))"
    }
}
