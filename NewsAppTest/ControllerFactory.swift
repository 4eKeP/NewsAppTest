//
//  ControllerFactory.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import UIKit

enum ControllerType {
    case newsListViewController
    case favouritesViewController
}

final class ControllerFactory {
    
    func setupController(of type: ControllerType) -> UINavigationController {
        switch type {
        case .newsListViewController:
            let newsListController = NewsListViewController()
            let newsListNavItem = createNavigation(
                with: String(localized: "Tab.ListTitle"),
                and: UIImage(systemName: "square.stack"),
                vc: newsListController)
            return newsListNavItem
        case .favouritesViewController:
            let favouritesController = FavouritesViewController()
            let favouritesNavItem = createNavigation(
                with: String(localized: "Tab.FavTitle"),
                and: UIImage(systemName: "star"),
                vc: favouritesController)
            return favouritesNavItem
        }
    }
    
    func setupTabBarController() -> UIViewController {
        let tabBarController = TabBarController(controllersFactory: self)
        return tabBarController
    }
    
    private func createNavigation(with title: String,
                                  and image: UIImage?,
                                  vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
}

