//
//  MainTabBarC.swift
//  MyMysic
//
//  Created by Anna Nosyk on 18/07/2022.
//

import UIKit

protocol MainTabBarControllerDelegate: AnyObject {
    func minimizeSongDetailView()
    func maxmizeSongDetailView(viewModel: AllMusicViewModel.Cell?)
}

class MainTabBarC: UITabBarController {
    
    let myMusic = MyMusicVC()
    let searchIcon = UIImage(systemName: "magnifyingglass")
    let musicIcon = UIImage(systemName: "music.quarternote.3")
    
    let allMusicVC: AllMusicViewController = AllMusicViewController.loadFromStoryboard()
    
    let songDetailView: SongDetailView = SongDetailView.loadFromNib()
    
    // for animation song detail view
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [ generateNavigationController(rootVc: allMusicVC, navigTitle: "All music list", title: "Search music", image: searchIcon!),
                            generateNavigationController(rootVc: myMusic, navigTitle: "My music list", title: "My music", image: musicIcon!)
        ]
        
        setupDetailViewWithAnimation()
        allMusicVC.tabBarDelegate = self
        
    }
    
    
    private func generateNavigationController(rootVc: UIViewController,navigTitle: String, title: String, image: UIImage) -> UIViewController {
        let navigVC = UINavigationController(rootViewController: rootVc)
        navigVC.tabBarItem.title = title
        rootVc.navigationItem.title = navigTitle
        navigVC.tabBarItem.image = image
        return navigVC
    }
    
    
    private func setupDetailViewWithAnimation() {
        songDetailView.animationDelegate = self
        songDetailView.delegate = allMusicVC
        view.insertSubview(songDetailView, belowSubview: tabBar)
        //auto layout for animation
        songDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = songDetailView.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height)
        minimizedTopAnchorConstraint = songDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = songDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        bottomAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.isActive = true
        songDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        songDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
    }
    
}

extension MainTabBarC: MainTabBarControllerDelegate {
    func maxmizeSongDetailView(viewModel: AllMusicViewModel.Cell?) {
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            self.songDetailView.miniPlayerView.alpha = 0
            self.songDetailView.fullScreenStackView.alpha = 1
        },
                       completion: nil)
        
        guard let viewModel = viewModel else {return}
        self.songDetailView.set(viewModel: viewModel)

    }
    func minimizeSongDetailView() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
            self.songDetailView.miniPlayerView.alpha = 1
            self.songDetailView.fullScreenStackView.alpha = 0
        },
                       completion: nil)
    }
    
    
}
