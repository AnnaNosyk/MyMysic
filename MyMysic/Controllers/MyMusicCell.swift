//
//  MyMusicCell.swift
//  MyMysic
//
//  Created by Anna Nosyk on 29/07/2022.
//

import UIKit
import SDWebImage

class MyMusicCell: UITableViewCell {
    
    
    @IBOutlet weak var songImage: UIImageView!

    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var authorName: UILabel!
    
    func setSong(viewModel: AllMusicViewModel.Cell) {
        songName.text = viewModel.songName
        authorName.text = viewModel.artistName
        guard let url = URL(string: viewModel.imageUrlString ?? "") else {return}
        songImage.sd_setImage(with: url, completed: nil)
    }
    


  

}
