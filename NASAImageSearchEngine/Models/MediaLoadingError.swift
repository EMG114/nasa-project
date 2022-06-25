//
//  MediaLoadingError.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/31/20.


import Foundation

enum MediaLoadingError: String, Error {
    case imageError
    case mediaError
    case badParsing
    case badStatusCode
    case noMockObject
    case faultyURLString
}
