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
    
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var miniPlayerSongName: UILabel!
    @IBOutlet weak var miniplayerImage: UIImageView!
    @IBOutlet weak var miniPlayerNextSongButton: UIButton!
    @IBOutlet weak var miniPlayerPlayButton: UIButton!
    
    
    @IBOutlet weak var fullScreenStackView: UIStackView!
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var timeSongSlider: UISlider!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var finishTimeLabel: UILabel!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var soundSlider: UISlider!
    @IBOutlet weak var dropDownButton: UIButton!
    
    
    weak var delegate: SongMovingDelegate?
    weak var animationDelegate: MainTabBarControllerDelegate?
    
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
        setupGesture()
    }
    
   // MARK: - Setup
    func set(viewModel: AllMusicViewModel.Cell) {
        songName.text = viewModel.songName
        miniPlayerSongName.text = viewModel.songName
        authorName.text = viewModel.artistName
        playSong(previewUrl: viewModel.previewUrl)
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        miniPlayerPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        monitorStartTime()
        observeSongTime()
        // for image 500x500 size(transform from 100x100)
        let string600 = viewModel.imageUrlString?.replacingOccurrences(of: "100x100", with: "500x500")
        guard let url = URL(string: string600 ?? "") else { return }
        songImage.sd_setImage(with: url, completed: nil)
        miniplayerImage.sd_setImage(with: url, completed: nil)
        
    }
    
  //MARK: - Setup gestures
    private func setupGesture() {
        miniPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fullScreenViewTapGesture)))
        miniPlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(fullScreenPan)))
        // for swipe down songDetail view
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(miniPlayerDismissalPan)))
    }
    
    
    @objc func fullScreenViewTapGesture() {
        self.animationDelegate?.maxmizeSongDetailView(viewModel: nil)
    }
    
    @objc func fullScreenPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            fullScreenPanChanged(gesture: gesture)
        case .ended:
            fullScreenPanEnded(gesture: gesture)
        @unknown default:
            print("unknown default")
        }
    }
    
    private func fullScreenPanChanged(gesture: UIPanGestureRecognizer) {
        //heigh of view == where finger of user
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
       
        let newAlpha = 1 + translation.y / 200
        self.miniPlayerView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.fullScreenStackView.alpha = -translation.y / 200
    }
    
    private func fullScreenPanEnded(gesture: UIPanGestureRecognizer) {
        //heigh of view == where finger of user
        let translation = gesture.translation(in: self.superview)
        //speed of gesture
        let velocity = gesture.velocity(in: self.superview)
        //animste for songDetailView (go up or down) - where closer finger of user
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                self.animationDelegate?.maxmizeSongDetailView(viewModel: nil)
            } else {
                self.miniPlayerView.alpha = 1
                self.fullScreenStackView.alpha = 0
            }
        }, completion: nil)
    }
    
    
    @objc func miniPlayerDismissalPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: self.superview)
            fullScreenStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)

        case .ended:
            let translation = gesture.translation(in: self.superview)
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                self.fullScreenStackView.transform = .identity
                if translation.y > 50 {
                    self.animationDelegate?.minimizeSongDetailView()
                }
            }, completion: nil)
        @unknown default:
            print("@unknown default")
        }
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
    
    //change time song with the slider
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
        self.animationDelegate?.minimizeSongDetailView()
       // self.removeFromSuperview()
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
    // 0 - back, 1- play, 2-forward 3 -play mini, 4-forward mini
        
        switch sender.tag {
        case 0 : // previous song
            let songViewModel = delegate?.moveBack()
            guard let previousSong = songViewModel else {return}
            set(viewModel: previousSong)
        case 1,3: // play, pause song
            if player.timeControlStatus == .paused {
                player.play()
                playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                miniPlayerPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                enlargeSongImage()
            } else {
                player.pause()
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                miniPlayerPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                reduceSongImage()
            }
        case 2,4: // next song
            let songViewModel = delegate?.moveForward()
            guard let nextSong = songViewModel else {return}
            set(viewModel: nextSong)
            
        default:
            break
        }
       
    }
    
    
    
}
