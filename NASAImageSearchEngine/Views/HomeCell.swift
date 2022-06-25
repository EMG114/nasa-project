//
//  HomeCell.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/29/20.


import UIKit

class HomeCell: UICollectionViewCell {
    
    // MARK: - PROPERTIES
    var viewModel: HomeCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {return}
            setImage(result: viewModel.bindableImage.value)
            viewModel.bindableImage.bind(observer: { [weak self] (result) in
                self?.setImage(result: result)
            })
        }
    }
    
    // MARK: - LIFE CYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI ELEMENT
    var imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "fuzzy"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func setImage(result: Result<UIImage, MediaErrorWrapper>?) {
        guard let result = result else {return}
        DispatchQueue.main.async {
            switch result {
            case .failure(_):
                self.imageView.image = #imageLiteral(resourceName: "fuzzy")
            case .success(let image):
                self.imageView.image = image
            }
        }
    }
}
