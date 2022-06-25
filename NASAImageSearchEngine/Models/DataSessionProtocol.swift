//
//  DataSessionProtocol.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/28/20.


import Foundation

protocol DataSessionProtocol {
    func loadData(from url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: DataSessionProtocol {
    func loadData(from url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = dataTask(with: url) { (data, response, error) in
            completionHandler(data, response, error)
        }
        task.resume()
    }
}
