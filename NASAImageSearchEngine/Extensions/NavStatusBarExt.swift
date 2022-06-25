//
//  NavStatusBarExt.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 2/3/20.


import UIKit

var currentStatusBarStyle = UIStatusBarStyle.lightContent

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return currentStatusBarStyle
    }
}
