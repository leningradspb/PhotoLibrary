//
//  MainTabBarController.swift
//  PhotoLibrary
//
//  Created by Eduard Sinyakov on 20/08/2019.
//  Copyright © 2019 Eduard Sinyakov. All rights reserved.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        view.backgroundColor = .gray
        
        let photosVC = PhotosCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
       
        
        viewControllers = [generateNavigationController(rootViewController: photosVC, title: "Photos", image: UIImage(named: "pictures")!), generateNavigationController(rootViewController: ViewController(), title: "Favourites", image: UIImage(named: "heart")!)]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
    }
    
}
