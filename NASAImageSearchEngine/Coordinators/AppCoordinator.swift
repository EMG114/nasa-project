//
//  AppCoordinator.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 2/17/20.

import UIKit

class AppCoordinator: Coordinator {
    // MARK: - PROPERTIES
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var window: UIWindow
    
    // MARK: - LIFE CYCLE
    init(window: UIWindow, navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    // MARK: - METHOD
    func start() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}
