//
//  Coordinator.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 2/11/20.


import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

