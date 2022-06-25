//
//  HomeView.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/29/20.

import UIKit

class HomeView: UIView {
    
    // MARK: - LIFE CYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
        addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        addSubview(textlabel)
        textlabel.anchor(top: imageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, paddingTop: 32, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - UI ELEMENTS
    lazy var collectionView: UICollectionView = {
        let cvFlowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvFlowLayout)
        cv.isHidden = true
        return cv
    }()
    
    let imageView: UIImageView = {
        let image = UIImage(systemName: "arrow.up") ?? UIImage(named: "arrow.up")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        return imageView
    }()
    
    let textlabel: UILabel = {
        let label = UILabel()
        label.attributedText = AStringCreator.helveticaAString(style: .helveticaNeue, text: "Tap on the search bar above to begin search.", size: 16, foregroundColor: .white, backgroundColor: .clear)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - METHOD
    func viewTransition() {
        let transitionOptions: UIView.AnimationOptions = [
            .transitionFlipFromRight,
            .showHideTransitionViews
        ]
        UIView.transition(with: imageView, duration: 0.5, options: transitionOptions, animations: {
            self.collectionView.isHidden = false
        })

        UIView.transition(with: collectionView, duration: 0.5, options: transitionOptions, animations: {
            self.imageView.isHidden = true
            self.textlabel.isHidden = true
        })
    }
}
