//
//  NASAImageSearchEngineTests.swift
//  NASAImageSearchEngineTests
//
//  Created by Erica Gutierrez on 1/28/20.


import XCTest
@testable import NASAImageSearchEngine

class NetworkServiceTests: XCTestCase {

    func testReturn100MediaObjects() {
        let mockSession = MockSession(mockSessionOption: .testNetworkRequest)
        let networkService = NetworkService(session: mockSession)
        let urlString = "https://images-api.nasa.gov/search?media_type=image&page=1&q=earth"
        let expectation = XCTestExpectation(description: "wait for testHasCorrectParseResult")
        networkService.loadMedia(urlString: urlString) { (result) in
            switch result {
            case .failure(_):
                XCTFail()
                expectation.fulfill()
            case .success(let mediaObjects):
                XCTAssertTrue(mediaObjects.count == 100)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testParseJSONObject() {
        let mockSession = MockSession(mockSessionOption: .testNetworkRequest)
        let networkService = NetworkService(session: mockSession)
        let nasaID = "nhq201804190012"
        let urlString = "https://images-api.nasa.gov/search?media_type=image&page=1&q=\(nasaID)"
        let expectation = XCTestExpectation(description: "wait for testParseJSONObject")
        networkService.loadMedia(urlString: urlString) { (result) in
            switch result {
            case .failure(_):
                XCTFail()
                expectation.fulfill()
            case .success(let mediaObjects):
                let mediaObject = mediaObjects.first
                // CHECK IMAGE
                let imageURLString = mediaObject?.links.first?.href
                XCTAssertEqual(imageURLString, "https://images-assets.nasa.gov/image/NHQ201804190012/NHQ201804190012~thumb.jpg", "ImageURLString doesn't match")
                // CHECK DATA
                let data = mediaObject?.data.first
                let nasaID = data?.nasaId
                XCTAssertEqual(nasaID, "NHQ201804190012", "NASA ID doesn't match")
                let title = data?.title
                XCTAssertEqual(title, "NASA Earth Day 2018", "Title doesn't match")
                let description = data?.description
                XCTAssertEqual(description, "A visitor learns about Earth at one of NASA's exhibits at the Earth Day event on Thursday, April 19, 2018 at Union Station in Washington, D.C. Photo Credit: (NASA/Aubrey Gemignani)", "Description doesn't match")
                let location = data?.location
                XCTAssertEqual(location, "Union Station", "Location doesn't match")
                let photographer = data?.photographer
                XCTAssertEqual(photographer, "NASA/Aubrey Gemignani", "Photographer doesn't match")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testReturnBadStatusCodeError() {
        let mockSession = MockSession(mockSessionOption: .testBadStatusCode)
        let networkService = NetworkService(session: mockSession)
        let nasaID = "NHQ201804190012"
        let urlString = "https://images-api.nasa.gov/search?media_type=image&page=1&q=\(nasaID)"
        let expectation = XCTestExpectation(description: "wait for testBadStatusCode")
        networkService.loadMedia(urlString: urlString) { (result) in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.errorType, MediaLoadingError.badStatusCode, "Bad status code error doesn't match")
                expectation.fulfill()
            case .success(_):
                XCTFail()
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testReturnMediaError() {
        let mockSession = MockSession(mockSessionOption: .testNoData)
        let networkService = NetworkService(session: mockSession)
        let nasaID = "NHQ201804190012"
        let urlString = "https://images-api.nasa.gov/search?media_type=image&page=1&q=\(nasaID)"
        let expectation = XCTestExpectation(description: "wait for testReturnMediaError")
        networkService.loadMedia(urlString: urlString) { (result) in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.errorType, MediaLoadingError.mediaError, "Media Error code doesn't match")
                expectation.fulfill()
            case .success(_):
                XCTFail()
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10)
    }
}
