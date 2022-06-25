//
//  MediaErrorWrapper.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 2/3/20.


import Foundation

struct MediaErrorWrapper: Error {
    let errorType: MediaLoadingError
    let titleMessage: String
    let bodyMessage: String
    
    init(errorType: MediaLoadingError, errorCode: String?) {
        self.errorType = errorType
        switch errorType {
        case .badParsing:
            titleMessage = "Internal System Issue"
            bodyMessage = "Unable to parse NASA media data(errorcode: \(errorType)."
        case .badStatusCode:
            titleMessage = "HTTP Status Code Issue"
            bodyMessage = "Bad status code(errorcode: \(errorCode ?? "no status code")."
        case .imageError:
            titleMessage = "Unable to Display Image"
            bodyMessage = "We're not able to load the image from NASA. Therefore I'll show you an image of my dog Fuzzy! On a more serious note, report this bug if this is not a network issue."
        case .mediaError:
            titleMessage = "Unable to Display Media"
            bodyMessage = "We could be experiencing network issue."
        case .faultyURLString:
            titleMessage = "Bad URL"
            bodyMessage = "This is not a URL: \(errorCode ?? "There is no URL"). Please report this to https://www.nasa.gov/about/contact/index.html"
        case .noMockObject:
            titleMessage = "Internal Error"
            bodyMessage = "No Mock Object"
        }
    }
}
