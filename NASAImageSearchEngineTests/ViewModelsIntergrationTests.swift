//
//  HomeViewModeTests.swift
//  NASAImageSearchEngineTests
//
//  Created by Erica Gutierrez on 1/31/20.


import XCTest
@testable import NASAImageSearchEngine

class ViewModelsIntergrationTests: XCTestCase {
    
    func testHomeViewModelFetchingIndexPaths() {
        let mockSession = MockSession(mockSessionOption: .testNetworkRequest)
        let networkService = NetworkService(session: mockSession)
        let viewModel = HomeViewModel(networkService: networkService)
        let expectation = XCTestExpectation(description: "wait for testHomeViewModelFetchingIndexPaths")
        viewModel.bindableNewIndexPaths.bind { (indexPaths) in
            guard let indexPaths = indexPaths else {return}
            XCTAssertEqual(indexPaths.count, 100, "")
            XCTAssertEqual(indexPaths.first?.item, 0, "First indexPath.item should be 0")
            XCTAssertEqual(indexPaths.last?.item, 99, "Last indexPath.item shold be 99")
            expectation.fulfill()
        }
        let textfield = UITextField(frame: .zero)
        textfield.text = "earth"
        viewModel.textFieldDidEndEditing(textfield)
        wait(for: [expectation], timeout: 10)
    }
    
    func testHomeCellViewModelLoadImage() {
        let imageURLString = "https://images-assets.nasa.gov/image/NHQ201804190012/NHQ201804190012~thumb.jpg"
        let mockSession = MockSession(mockSessionOption: .testNetworkRequest)
        let networkService = NetworkService(session: mockSession)
        let homeViewModel = HomeCellViewModel(urlString: imageURLString, networkService: networkService)
        let expectation = XCTestExpectation(description: "wait for testShowBindableImageInHomeCellViewModel")
        guard let result = homeViewModel.bindableImage.value else {
            XCTFail()
            return}
        switch result {
        case .failure(_):
            XCTFail()
            expectation.fulfill()
        case .success(_):
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testDetailViewModelLoadImage() {
        let mockSession = MockSession(mockSessionOption: .testNetworkRequest)
        let networkService = NetworkService(session: mockSession)
        let homeViewModel = HomeViewModel(networkService: networkService)
        let expectation = XCTestExpectation(description: "wait for testDetailViewModel")
        homeViewModel.bindableShowDetailView.bind { (devailViewModel) in
            guard let detailViewModel = devailViewModel else {
                XCTFail()
                expectation.fulfill()
                return
            }
            detailViewModel.loadImage { (result) in
                switch result {
                case .failure(_):
                    XCTFail()
                    expectation.fulfill()
                case .success(_):
                    expectation.fulfill()
                }
                expectation.fulfill()
            }
        }
        let textfield = UITextField(frame: .zero)
        textfield.text = "NHQ201804190012"
        homeViewModel.textFieldDidEndEditing(textfield)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        homeViewModel.collectionView(collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
        wait(for: [expectation], timeout: 10)
    }
}
