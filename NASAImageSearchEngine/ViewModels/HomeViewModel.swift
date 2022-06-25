//
//  HomeViewModel.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/29/20.


import UIKit

class HomeViewModel: NSObject {
    // MARK: - PROPERTIES
    static let cellID = "homeCellID"
    private let padding: CGFloat = 4
    private let networkService: MediaProtocol
    private var userInput = ""
    private var shouldPaginate = false
    private var lastUpdateMediaObjectsCount = 0
    private var currentPageIndex = 1
    private var mediaObjects = [MediaObject]()
    
    var bindableNewIndexPaths = Bindable<[IndexPath]>()
    var bindableShowDetailView = Bindable<DetailViewModel>()
    var bindableHandleError = Bindable<MediaErrorWrapper>()
    
    init(networkService: MediaProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - METHODS
    func updateShouldPaginateStatus() {
        shouldPaginate = lastUpdateMediaObjectsCount > 99 ? true : false
    }
    
    // MARK: - PRIVATE METHOD
    private func queryNASAMedia(searchString: String, pageIndex: Int) {
        guard let encodedSearchString = searchString.customEncoding() else {return}
        let pageURLString = "&page=\(pageIndex)"
        let urlString = "\(BaseURL.searchImageFreeFormQuery.rawValue)\(pageURLString)&q=\(encodedSearchString)"
        networkService.loadMedia(urlString: urlString) { [unowned self] (result) in
            switch result {
            case .failure(let error):
                self.bindableHandleError.value = error
            case .success(let mediaObjects):
                self.lastUpdateMediaObjectsCount += mediaObjects.count
                if self.currentPageIndex > 1 {
                    self.mediaObjects.append(contentsOf: mediaObjects)
                    self.bindableNewIndexPaths.value = self.generateIndexpaths(endingIndex: self.lastUpdateMediaObjectsCount - 100)
                } else {
                    imageCache.removeAll()
                    self.lastUpdateMediaObjectsCount = mediaObjects.count
                    self.mediaObjects = mediaObjects
                    self.bindableNewIndexPaths.value = self.generateIndexpaths(endingIndex: 0)
                }
            }
        }
    }
    
    private func generateIndexpaths(endingIndex: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        (endingIndex...endingIndex + 99).forEach { (item) in
            let indexPath = IndexPath(item: item, section: 0)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    
    private func createHomeCellViewModel(index: Int) -> HomeCellViewModel {
        let imageURLString = mediaObjects[index].links.first?.href
        return HomeCellViewModel(urlString: imageURLString, networkService: networkService)
    }
}

// MARK: - UICollectionViewDataSource,  UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
extension HomeViewModel: UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewModel.cellID, for: indexPath) as? HomeCell
        cell?.viewModel = createHomeCellViewModel(index: indexPath.row)
        cell?.layer.cornerRadius = 10
        cell?.layer.borderColor = UIColor.white.cgColor
        cell?.layer.borderWidth = 2
        cell?.clipsToBounds = true
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewModel = DetailViewModel(mediaObject: mediaObjects[indexPath.row], networkService: networkService)
        bindableShowDetailView.value = detailViewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalPadding = padding * 2
        let width = (collectionView.frame.width - totalPadding ) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        guard offsetY > contentHeight - scrollView.frame.height && shouldPaginate else {return}
        shouldPaginate = !shouldPaginate
        currentPageIndex += 1
        queryNASAMedia(searchString: userInput, pageIndex: currentPageIndex)
    }
}

// MARK: - UITextFieldDelegate
extension HomeViewModel: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard
            let userInput = textField.text?.lowercased(),
            !userInput.isEmpty
            else {return}
        self.userInput = userInput
        currentPageIndex = 1
        queryNASAMedia(searchString: userInput, pageIndex: currentPageIndex)
    }
    
}
