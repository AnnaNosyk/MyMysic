//
//  MainTabBarC.swift
//  MyMysic
//
//  Created by Anna Nosyk on 18/07/2022.
//

import UIKit

class MainTabBarC: UITabBarController {
    
    let allMusic = AllMusicVC()
    let myMusic = MyMusicVC()
    let searchIcon = UIImage(systemName: "magnifyingglass")
    let musicIcon = UIImage(systemName: "music.quarternote.3")
    
    let allMusicVC: AllMusicViewController = AllMusicViewController.loadFromStoryboard()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        viewControllers = [ generateNavigationController(rootVc: allMusicVC, navigTitle: "All music list", title: "Search music", image: searchIcon!),
                            generateNavigationController(rootVc: myMusic, navigTitle: "My music list", title: "My music", image: musicIcon!)
        ]
    
    }
    
    
    private func generateNavigationController(rootVc: UIViewController,navigTitle: String, title: String, image: UIImage) -> UIViewController {
        let navigVC = UINavigationController(rootViewController: rootVc)
        navigVC.tabBarItem.title = title
        rootVc.navigationItem.title = navigTitle
        navigVC.tabBarItem.image = image
        return navigVC
    }
    



}
