//
//  SearchResult+CoreDataProperties.swift
//  Project_v6
//
//  Created by Константин Вороненко on 25.02.22.
//
//

import Foundation
import CoreData


extension SearchResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchResult> {
        return NSFetchRequest<SearchResult>(entityName: "SearchResult")
    }

    @NSManaged public var text: String?

}

extension SearchResult : Identifiable {

}
