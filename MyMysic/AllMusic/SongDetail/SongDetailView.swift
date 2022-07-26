//
//  SongDetailView.swift
//  MyMysic
//
//  Created by Anna Nosyk on 25/07/2022.
//

import UIKit
import SDWebImage
import AVKit

protocol SongMovingDelegate: AnyObject {
    func moveBack() -> AllMusicViewModel.Cell?
    func moveForward() -> AllMusicViewModel.Cell?
}

class SongDetailView: UIView {
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var timeSongSlider: UISlider!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var finishTimeLabel: UILabel!
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var soundSlider: UISlider!
    
    weak var delegate: SongMovingDelegate?
    
    let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
         return player
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let scale = 0.8
        songImage.transform = CGAffineTransform(scaleX: scale, y: scale)
        soundSlider.value = 0.2
    }
    
   // MARK: - Setup
    func set(viewModel: AllMusicViewModel.Cell) {
        songName.text = viewModel.songName
        authorName.text = viewModel.artistName
        playSong(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        observeSongTime()
        // for image 600x600 size
        let string600 = viewModel.imageUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        songImage.sd_setImage(with: url, completed: nil)
    }
    
    
    
    
    private func playSong(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else {return}
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.volume = soundSlider.value
        player.play()
    }
    
    // MARK: -  Time settings
    // monitor time when song start play(for change image size)
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeSongImage()
        }
    }
    
    private func observeSongTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.startTimeLabel.text = time.convertToString()
            let totalTime = self?.player.currentItem?.duration
            let timeToFinishStr = ((totalTime ?? CMTimeMake(value: 1, timescale: 1)) - time).convertToString()
            self?.finishTimeLabel.text = "- \(timeToFinishStr)"
            self?.updateSongTimeSlider()
        }
    }
    
    private func updateSongTimeSlider() {
        
        let timeCurrent = CMTimeGetSeconds(player.currentTime())
        let songTimeDuration =  CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = timeCurrent / songTimeDuration
        self.timeSongSlider.value = Float(percentage)
    }
    
    // MARK: - Animations
    
    private func enlargeSongImage() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.songImage.transform = .identity
        }, completion: nil)
    }
    
    private func reduceSongImage() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            let scale = 0.8
            self.songImage.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func dropDownAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    
    
    @IBAction func songTimeSliderAction(_ sender: UISlider) {
        let persentage = sender.value
        guard let duration = player.currentItem?.duration else {return}
        let secondsDuration = CMTimeGetSeconds(duration)
        // where now play song
        let timeInSong = Float64(persentage) * secondsDuration
        let songTime = CMTimeMakeWithSeconds(timeInSong, preferredTimescale: 1)
        player.seek(to: songTime)
    }
    
    
    
    @IBAction func soundSongSliderAction(_ sender: Any) {
        player.volume = soundSlider.value
    }
    
    @IBAction func changeSongsAction(_ sender: UIButton) {
    // 0 - back, 1- play, 2-forward
        
        switch sender.tag {
        case 0 : // previous song
            let songViewModel = delegate?.moveBack()
            guard let previousSong = songViewModel else {return}
            set(viewModel: previousSong)
        case 1: // play, pause song
            if player.timeControlStatus == .paused {
                player.play()
                playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                enlargeSongImage()
            } else {
                player.pause()
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                reduceSongImage()
            }
        case 2: // next song
            let songViewModel = delegate?.moveForward()
            guard let nextSong = songViewModel else {return}
            set(viewModel: nextSong)
            
        default:
            break
        }
       
    }
    
    
    
}
