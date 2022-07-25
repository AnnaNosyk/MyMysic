//
//  SongDetailView.swift
//  MyMysic
//
//  Created by Anna Nosyk on 25/07/2022.
//

import UIKit
import SDWebImage
import AVKit

class SongDetailView: UIView {

    

    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var timeSongSlider: UISlider!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var finishTimeLabel: UILabel!
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var soundSlider: UISlider!
    
    let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
         return player
    }()
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    
    func set(viewModel: AllMusicViewModel.Cell) {
        songName.text = viewModel.songName
        authorName.text = viewModel.artistName
        playSong(previewUrl: viewModel.previewUrl)
        // for image 600x600 size
        let string600 = viewModel.imageUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        songImage.sd_setImage(with: url, completed: nil)
    }
    
    
    private func playSong(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else {return}
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

    @IBAction func dropDownAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    
    
    @IBAction func songTimeSliderAction(_ sender: UISlider) {
    }
    
    
    
    @IBAction func soundSongSliderAction(_ sender: Any) {
    }
    
    @IBAction func changeSongsAction(_ sender: UIButton) {
    // 0 - back, 1- play, 2-forward
        
        switch sender.tag {
        case 0 :
            print("back")
        case 1:
            if player.timeControlStatus == .paused {
                player.play()
                playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            } else {
                player.pause()
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        case 2:
            print("forward")
            
        default:
            break
        }
       
    }
    
    
    
}
