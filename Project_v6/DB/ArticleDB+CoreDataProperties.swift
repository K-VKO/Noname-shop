//
//  Article+CoreDataProperties.swift
//  Project_v6
//
//  Created by Константин Вороненко on 24.02.22.
//
//

import Foundation
import CoreData


extension ArticleDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleDB> {
        return NSFetchRequest<ArticleDB>(entityName: "ArticleDB")
    }

    @NSManaged public var newsDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var urlToImage: String?

}

extension ArticleDB : Identifiable {

}
