//
//  MockSession.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/31/20.

import Foundation

enum MockURLString: String {
    case mockEarthPage1 = "https://images-api.nasa.gov/search?media_type=image&page=1&q=earth"
    case mockEarthPage2 = "https://images-api.nasa.gov/search?media_type=image&page=2&q=earth"
    case mockSingleMedia = "https://images-api.nasa.gov/search?media_type=image&page=1&q=nhq201804190012"
    case mockImage = "https://images-assets.nasa.gov/image/NHQ201804190012/NHQ201804190012~thumb.jpg"
}

enum MockSessionOption {
    case testNetworkRequest
    case testBadStatusCode
    case testNoData
}

class MockSession: DataSessionProtocol {
    var mockSessionOption: MockSessionOption
    
    init(mockSessionOption: MockSessionOption) {
        self.mockSessionOption = mockSessionOption
    }
    
    func loadData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        switch mockSessionOption {
        case .testNetworkRequest:
            let tuple = loadMockData(url: url)
            completionHandler(tuple.data, tuple.urlResponse, tuple.error)
        case .testBadStatusCode:
            let tuple = loadBadStatusCode(from: url)
            completionHandler(tuple.data, tuple.urlResponse, tuple.error)
        case .testNoData:
            let tuple = loadBadData(from: url)
            completionHandler(tuple.data, tuple.urlResponse, tuple.error)
        }
    }
    
    private func loadMockData(url: URL) -> (data: Data?, urlResponse: URLResponse?, error: Error?) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "mock", headerFields: nil)
        guard let path = getMockObjectPath(url: url) else {
            return (data: nil, urlResponse: response, error: MediaLoadingError.noMockObject)
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            return (data: data, urlResponse: response, error: nil)
        } catch let error {
            return (data: nil, urlResponse: response, error: error)
        }
        
    }
    
    private func loadBadStatusCode(from url: URL) -> (data: Data?, urlResponse: URLResponse?, error: Error?) {
        let error = MediaLoadingError.badStatusCode
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: "mock", headerFields: nil)
        return (data: nil, urlResponse: response, error: error)
    }
    
    private func loadBadData(from url: URL) -> (data: Data?, urlResponse: URLResponse?, error: Error?) {
        let error = MediaLoadingError.mediaError
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "mock", headerFields: nil)
        return (data: nil, urlResponse: response, error: error)
    }
    
    private func getMockObjectPath(url: URL) -> String? {
        switch url.absoluteString {
        case MockURLString.mockEarthPage1.rawValue:
            return Bundle.main.path(forResource: "MockEarthPage1", ofType: "json")
        case MockURLString.mockEarthPage2.rawValue:
            return Bundle.main.path(forResource: "MockEarthPage2", ofType: "json")
        case MockURLString.mockSingleMedia.rawValue:
            return Bundle.main.path(forResource: "MockSingleMedia", ofType: "json")
        case MockURLString.mockImage.rawValue:
            return Bundle.main.path(forResource: "MockImageNHQ201804190012", ofType: "jpg")
        default:
            return nil
        }
    }
}
