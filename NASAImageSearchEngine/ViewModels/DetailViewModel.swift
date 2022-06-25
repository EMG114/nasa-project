//
//  DetailViewModel.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/29/20.


import UIKit

class DetailViewModel: NSObject {
    // MARK: - PROPERTIES
    static let cellID = "detailCellID"
    private let mediaObject: MediaObject
    private var datasource = [String]()
    private let networkService: MediaProtocol
    
    // MARK: - LIFE CYCLE
    init(mediaObject: MediaObject, networkService: MediaProtocol = NetworkService()) {
        self.mediaObject = mediaObject
        self.networkService = networkService
        super.init()
        datasource = createDataSource(mediaObject: mediaObject)
    }
    
    // MARK: - PUBLIC METHOD
    func loadImage(completion: @escaping (Result<UIImage, MediaErrorWrapper>) -> Void) {
        guard let imageURLString = mediaObject.links.first?.href else {
            let wrapper = MediaErrorWrapper(errorType: .faultyURLString, errorCode: nil)
            completion(.failure(wrapper))
            return
        }
        networkService.loadImage(urlString: imageURLString) { (result) in
            completion(result)
        }
    }
    
    // MARK: - PRIVATE METHOD
    private func createDataSource(mediaObject: MediaObject) -> [String] {
        guard let data = mediaObject.data.first else {return []}
        var result = [String]()
        let title = "Title: \(data.title)"
        let description = "Description: \(data.description ?? data.description508 ?? "")"
        result.append(title)
        result.append(description)
        if let photographer = data.photographer {
            let fullPhotographerString = "Photographer: \(photographer)"
            result.append(fullPhotographerString)
        }
        guard let location = data.location else {return result}
        let fullLocationString = "Location: \(location)"
        result.append(fullLocationString)
        return result
    }
}

// MARK: - TABLEVIEW DATASOURCE & DELEGATE
extension DetailViewModel: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailViewModel.cellID, for: indexPath)
        cell.textLabel?.attributedText = AStringCreator.helveticaAString(style: .helveticaNeue, text: datasource[indexPath.row], size: 16, foregroundColor: .black, backgroundColor: .clear)
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
