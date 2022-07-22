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
    
    
    func set(viewModel: SongViewModelProtocol) {
        songName.text = viewModel.songName
        authorName.text = viewModel.artistName
        albumName.text = viewModel.albumName
        guard let url = URL(string: viewModel.imageUrlString ?? "") else {return}
        songImage.sd_setImage(with: url, completed: nil)
    }

}
