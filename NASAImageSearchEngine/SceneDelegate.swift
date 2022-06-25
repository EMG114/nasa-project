//
//  SceneDelegate.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/28/20.


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }
}
