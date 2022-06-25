//
//  ViewController.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/28/20.

import UIKit

class HomeViewController: UIViewController {
    // MARK: - PROPERTIES
    let homeView = HomeView()
    let viewModel: HomeViewModel
    weak var coordinator: HomeCoordinator?
    
    // MARK: - LIFE CYCLE
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupCollectionView()
        setupSearchBar()
        bindableInsertNewIndexPaths()
        bindableShowDetailViewController()
        bindableShowAlertController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = homeView
    }
    
    // MARK: - PRIVATE METHOD
    private func setupCollectionView() {
        self.homeView.collectionView.delegate = viewModel
        self.homeView.collectionView.dataSource = viewModel
        self.homeView.collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeViewModel.cellID)
    }
    
    private func setupSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.searchTextField.delegate = viewModel
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search here for NASA Space images"
        navigationItem.searchController = search
        let attributedStringDict = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.black]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributedStringDict , for: .normal)
        search.delegate = self
    }
    
    private func bindableInsertNewIndexPaths() {
        viewModel.bindableNewIndexPaths.bind { [unowned self] (indexPaths) in
            guard
                let indexPaths = indexPaths,
                !indexPaths.isEmpty
                else {return}
            DispatchQueue.main.async {
                if indexPaths.first?.item == 0 {
                    self.homeView.collectionView.reloadData()
                    self.homeView.viewTransition()
                    self.homeView.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                } else {
                    self.homeView.collectionView.insertItems(at: indexPaths)
                }
                self.viewModel.updateShouldPaginateStatus()
            }
        }
    }
    
    private func bindableShowDetailViewController() {
        viewModel.bindableShowDetailView.bind { [unowned self] (detailViewModel) in
            guard let detailViewModel = detailViewModel else {return}
            self.coordinator?.showDetailViewController(detailViewModel: detailViewModel)
        }
    }
    
    private func bindableShowAlertController() {
        viewModel.bindableHandleError.bind { (error) in
            DispatchQueue.main.async {
                guard let error = error else {return}
                let alertController = UIAlertController(title: error.titleMessage, message: error.bodyMessage, preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                alertController.addAction(dismissAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UISearchControllerDelegate
extension HomeViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        currentStatusBarStyle = .default
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        currentStatusBarStyle = .lightContent
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
}
