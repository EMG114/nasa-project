//
//  Bindable.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/29/20.


import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?)->())?
    
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
    
}
