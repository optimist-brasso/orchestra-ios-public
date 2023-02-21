//
//  HallSoundAudioPlayerViewController.swift
//  Orchestra
//
//  Created by rohit lama on 28/04/2022.
//
//

import UIKit
import PBPopupController

class HallSoundAudioPlayerViewController: UIViewController {
    
    //MARK: - Properties
    var presenter: HallSoundAudioPlayerModuleInterface?
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    
    //MARK: - IBOutlets
    @IBOutlet weak var audioPlayerMinimizerView: UIView?
    @IBOutlet weak var audioImageView: UIImageView?
    @IBOutlet weak var audioEnglishTitleLabel: UILabel?
    @IBOutlet weak var audioNameInJapaneseNotationLabel: UILabel?
    @IBOutlet weak var hallTitleLabel: UILabel?
    @IBOutlet weak var hallSeatsLabel: UILabel?
    @IBOutlet weak var audioSlider: UISlider?
    @IBOutlet weak var audioCurrentTimeLabel: UILabel?
    @IBOutlet weak var titleAndHallSeperatorView: UIView?
    @IBOutlet weak var audioVolumeSlider: UIVolumeSlider?
    @IBOutlet weak var audioTotalDurationLabel: UILabel?
    @IBOutlet weak var playPauseButton: UIButton?
    
    //MARK: - VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        audioVolumeSlider?.activate()
        self.setup()
        presenter?.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        presenter?.playSong()
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK: - IBActions
    @IBAction func playAndPauseAudioButtonTapped(_ sender: Any) {
        presenter?.playSong()
    }
    
    @IBAction func forwardAudioButtonTapped(_ sender: Any) {
        presenter?.forwardAudio()
    }
    
    @IBAction func reverseAudioButtonTapped(_ sender: Any) {
        presenter?.reverseAudio()
    }
    
    @IBAction func nextAudioButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func previousAudioButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func audioSliderScrubbed(_ sender: UISlider) {
        presenter?.audioSliderScrubbed(Float(sender.value))
    }
    
    //MARK: - Other Functions
    private func setup() {
        setupViews()
        setupSliders()
        setupVolume()
    }
    
    private func setupViews() {
        audioImageView?.layer.cornerRadius = 5
        audioPlayerMinimizerView?.layer.cornerRadius = 5
        titleAndHallSeperatorView?.layer.borderWidth = 1
        titleAndHallSeperatorView?.layer.borderColor = UIColor(hexString: "B2964E").cgColor
    }
    
    private func setupSliders() {
        audioSlider?.value = .zero
        audioSlider?.setThumbImage(UIImage(named: "Ellipse103"), for: .normal)
        audioVolumeSlider?.setThumbImage(UIImage(named: "Ellipse102"), for: .normal)
        audioSlider?.minimumValue = .zero
    }

    private func setupVolume() {
        audioVolumeSlider?.updatePositionForSystemVolume()
    }
    
    private func setupData(_ model: HallSoundAudioPlayerViewModel) {
        audioImageView?.showImage(with: model.image) { image in
            NotificationCenter.default.post(name: Notification.passHallSoundDetailViewModel, object: image)
        }
        audioEnglishTitleLabel?.text = model.title
        audioNameInJapaneseNotationLabel?.text = model.titleJapanese
        hallTitleLabel?.text = model.venueTitle
        hallSeatsLabel?.text = model.seat
    }
    
    private func setupPlayPauseButton(_ isPlaying: Bool) {
        playPauseButton?.setImage(UIImage(systemName: "\(isPlaying ? "pause" : "play").circle.fill"), for: .normal)
        playPauseButton?.contentMode = .scaleToFill
        playPauseButton?.contentHorizontalAlignment = .fill
        playPauseButton?.contentVerticalAlignment = .fill
    }
    
    deinit {
        audioVolumeSlider?.deactivate()
    }
    
}

//MARK: - HallSoundAudioPlayerViewInterface
extension HallSoundAudioPlayerViewController: HallSoundAudioPlayerViewInterface {
    
    func showAudioDuration(_ time: String?) {
        audioTotalDurationLabel?.text = time
    }
    
    func showAudioTimeElapsed(_ timeElapsed: String?) {
        audioCurrentTimeLabel?.text = timeElapsed
    }
    
    func syncAudioDurationAndSlider(_ audioDuration: Float?) {
        guard let audioDuration = audioDuration else {
            return
        }
        audioSlider?.maximumValue = audioDuration
    }
    
    func syncAudioCurrentTimeAndSlider(_ audioTimeElapsed: Float?) {
        guard let audioTimeElapsed = audioTimeElapsed else {
            return
        }
        audioSlider?.value = audioTimeElapsed
    }
    
    func showAudioPlayerDetail(_ model: HallSoundAudioPlayerViewModel) {
        setupData(model)
    }
    
    func showPlayPauseStatus(_ isPlaying: Bool?) {
        if let isPlaying = isPlaying {
            setupPlayPauseButton(isPlaying)
        }
    }
    
}
