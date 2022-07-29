//
//  SongViewCell.swift
//  MyMysic
//
//  Created by Anna Nosyk on 22/07/2022.
//

import UIKit
import SDWebImage
protocol SongViewModelProtocol {
    var imageUrlString: String? { get }
    var songName: String { get }
    var artistName: String { get }
    var albumName: String { get }
    
}

class SongViewCell: UITableViewCell {
    
   static let cellId = "SongViewCell"
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var addSongBUtton: UIButton!
    
    
    var cell: AllMusicViewModel.Cell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        songImage.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func set(viewModel: AllMusicViewModel.Cell) {
        self.cell = viewModel
        //check if song already in user defaults
        let savedSongs = UserDefaults.standard.savedSongs()
        let alreadySave = savedSongs.firstIndex(where: {
            $0.songName == self.cell?.songName && $0.artistName == self.cell?.artistName
        }) != nil
        if alreadySave {
            addSongBUtton.isHidden = true
        } else {
            addSongBUtton.isHidden = false
        }
        songName.text = viewModel.songName
        authorName.text = viewModel.artistName
        albumName.text = viewModel.albumName
        guard let url = URL(string: viewModel.imageUrlString ?? "") else {return}
        songImage.sd_setImage(with: url, completed: nil)
    }
    
    
    @IBAction func addSongToMyList(_ sender: UIButton) {
        
        let userDefaults = UserDefaults.standard
        guard let cell = cell else {return}
        addSongBUtton.isHidden = true
        var listOfSongs = userDefaults.savedSongs()
       
        listOfSongs.append(cell)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: listOfSongs, requiringSecureCoding: false) {
            userDefaults.set(data, forKey: UserDefaults.mySongKey)
        }
       
    }

    }
    

