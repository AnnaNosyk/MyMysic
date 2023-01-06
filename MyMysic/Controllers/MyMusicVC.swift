//
//  ViewController.swift
//  MyMysic
//
//  Created by Anna Nosyk on 18/07/2022.
//

import UIKit

class MyMusicVC: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var mySongs = UserDefaults.standard.savedSongs()
    weak var tabBarDelegate: MainTabBarControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // view.backgroundColor = .white
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mySongs = UserDefaults.standard.savedSongs()
        tableView.reloadData()
    }
    
  
    
}

extension MyMusicVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMusicCell", for: indexPath) as! MyMusicCell
        
        let songs = mySongs[indexPath.row]
        cell.setSong(viewModel: songs)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        let tabBarVC = keyWindow?.rootViewController as? MainTabBarC
        tabBarVC?.songDetailView.delegate = self
        let songs = mySongs[indexPath.row]
        self.tabBarDelegate?.maxmizeSongDetailView(viewModel: songs)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let songs = mySongs[indexPath.row]
        let index = mySongs.firstIndex(of: songs)
        guard let myIndex = index else { return }
        mySongs.remove(at: myIndex)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: mySongs, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.mySongKey)
        }
        tableView.reloadData()
    }
    
    
}

extension MyMusicVC: SongMovingDelegate {
    
    private func getSong(isNext: Bool) ->AllMusicViewModel.Cell? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        tableView.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
        if isNext {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == mySongs.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = mySongs.count - 1
            }
        }
        tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let cellViewModel = mySongs[nextIndexPath.row]
        return cellViewModel
        
    }
    func moveBack() -> AllMusicViewModel.Cell? {
        return getSong(isNext: false)
    }
    
    func moveForward() -> AllMusicViewModel.Cell? {
        return getSong(isNext: true)
    }
    
    
}
