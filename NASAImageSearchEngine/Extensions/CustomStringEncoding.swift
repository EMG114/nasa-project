//
//  CustomStringEncoding.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/31/20.


import Foundation

extension String {
    func customEncoding() -> String? {
        var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
        allowedQueryParamAndKey.remove(charactersIn: ";/?:@&=+$, ")
        return self.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)
    }
}
