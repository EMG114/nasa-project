//
//  HomeCellViewModel.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/29/20.


import UIKit

class HomeCellViewModel {
    var bindableImage = Bindable<Result<UIImage, MediaErrorWrapper>>()
    init(urlString: String?, networkService: MediaProtocol = NetworkService()) {
        guard let urlString = urlString else {return}
        networkService.loadImage(urlString: urlString) { [weak self] (result) in
            self?.bindableImage.value = result
        }
    }
}


