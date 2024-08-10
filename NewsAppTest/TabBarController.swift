//
//  TabBarController.swift
//  NewsAppTest
//
//  Created by admin on 10.08.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    var controllerFactory: ControllerFactory
   
    init(controllersFactory: ControllerFactory) {
        self.controllerFactory = controllersFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabBars()
    }
    
    func configTabBars() {
        let newsListNavItem = controllerFactory.setupController(of: ControllerType.newsListViewController)
        let favouritesNavItem = controllerFactory.setupController(of: ControllerType.favouritesViewController)
        
        self.setViewControllers([newsListNavItem, favouritesNavItem], animated: true)
    }
}
