//
//  TabBar.swift
//  ActualProject_v2
//
//  Created by Константин Вороненко on 14.02.22.
//

import UIKit
import RxCocoa
import RxSwift
import CoreData

final class TabBar: UITabBarController{
    
    var fetchedResultsController: NSFetchedResultsController<ProductDB>!
    
    private func configureTabBar() {
        let nc1 = UINavigationController(rootViewController: MainShopVC.loadFromNib())
        
        nc1.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(named: "shop-icon"), tag: 0)
        

        let nc2 = UINavigationController(rootViewController: NewsVC.loadFromNib())
        nc2.tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "favorites-icon"), tag: 1)
        
        let vc3 = CartVC.loadFromNib()
        vc3.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(named: "cart-icon"), tag: 2)
        
        let vc4 = AccountVC.loadFromNib()
        vc4.tabBarItem = UITabBarItem(title: "Account", image: UIImage(named: "account-icon"), tag: 3)
        
        
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = .systemGreen
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        viewControllers = [nc1, nc2, vc3, vc4]
    }
    
    func reloadTabBarBadge() {
        if fetchedResultsController == nil {
            let request = NSFetchRequest<ProductDB>(entityName: "ProductDB")
            let sort = NSSortDescriptor(key: "shoppingCart", ascending: false)
            request.sortDescriptors = [sort]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataService.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
            if let productsCount = fetchedResultsController.fetchedObjects?.filter({ $0.shoppingCart != nil }).count {
                if productsCount > 0 {
                    self.tabBar.items?[2].badgeValue = "\(productsCount)"
                } else {
                    self.tabBar.items?[2].badgeValue = nil
                }
            }
        } catch {
            print("failed fetch")
        }
}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        reloadTabBarBadge()
    }
    
}

extension TabBar: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        reloadTabBarBadge()
    }
}
