//
//  DetailViewController.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/29/20.

import UIKit

class DetailViewController: UIViewController {
    // MARK: - PROPERTIES
    let detailView = DetailView()
    let viewModel: DetailViewModel
    
    // MARK: - LIFE CYCLE
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        detailView.tableView.delegate = viewModel
        detailView.tableView.dataSource = viewModel
        detailView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: DetailViewModel.cellID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
        loadImage()
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    // MARK: - PRIVATE METHOD
    private func loadImage() {
        viewModel.loadImage { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.detailView.imageView.image = #imageLiteral(resourceName: "fuzzy")
                    let alertController = UIAlertController(title: error.titleMessage, message: error.bodyMessage, preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                    alertController.addAction(dismissAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self.detailView.imageView.image = image
                }
            }
        }
    }
}
