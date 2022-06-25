//
//  HomeCoordinator.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 2/17/20.
//

import UIKit

class HomeCoordinator: Coordinator {
    // MARK: - PROPERTIES
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    // MARK: - LIFE CYCLE
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - METHOD
    func showDetailViewController(detailViewModel: DetailViewModel) {
        let viewController = DetailViewController(viewModel: detailViewModel)
        currentStatusBarStyle = .default
        self.navigationController.setNeedsStatusBarAppearanceUpdate()
        self.navigationController.pushViewController(viewController, animated: true)
    }

    func start() {
        let viewModel = HomeViewModel()
        let vc = HomeViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
}
