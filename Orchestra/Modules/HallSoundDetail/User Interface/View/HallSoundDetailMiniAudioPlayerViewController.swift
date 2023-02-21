//
//  HallSoundMiniAudioPlayerViewController.swift
//  Orchestra
//
//  Created by rohit lama on 04/05/2022.
//

import UIKit

class HallSoundDetailMiniAudioPlayerViewController: UIViewController {

    //MARK: - Properties
    var direction: HallSoundDirection?
    var viewModel: HallSoundDetailViewModel? {
        didSet {
            setData()
        }
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var mainBarView: UIView?
    @IBOutlet weak var audioImageView: UIImageView?
    @IBOutlet weak var playPauseButton: UIButton?
    @IBOutlet weak var audioEnglishTitleLabel: UILabel?
    @IBOutlet weak var audioJpTitleLabel: UILabel?
    @IBOutlet weak var seatLabel: UILabel?
    
    //MARK: - VC's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Setup Functions
    private func setup() {
        setupBarView()
        setupObservers()
    }
    
    private func setupBarView() {
        preferredContentSize.height = 112
        view.backgroundColor = .clear
        view.preservesSuperviewLayoutMargins = true
        mainBarView?.layer.shadowColor = UIColor.black.cgColor
        mainBarView?.layer.shadowOpacity = 0.5
        mainBarView?.layer.shadowRadius = 5
        mainBarView?.layer.shadowOffset = .zero
        mainBarView?.topCurve = 2
    }
    
    private func setData() {
        audioImageView?.showImage(with: viewModel?.image)
        audioEnglishTitleLabel?.text = viewModel?.title
        audioJpTitleLabel?.text = viewModel?.titleJapanese
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(setupUpdatesOfPlayPauseButton(_:)), name: Notification.audioPlayerPlayingStatus, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupAlbumCover(_:)), name: Notification.passHallSoundDetailViewModel, object: nil)
    }
    
    @objc private func setupUpdatesOfPlayPauseButton(_ notification: Notification?) {
        if let isPlaying = notification?.object as? Bool {
            if isPlaying {
                playPauseButton?.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            } else {
                playPauseButton?.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
    }
    
    @objc private func setupAlbumCover(_ notification: Notification) {
        if let tuple = notification.object as? (viewModel: HallSoundDetailViewModel, direction: HallSoundDirection) {
            let hallsoundViewModel = viewModel?.hallsounds?.element(at: tuple.direction.rawValue)
            seatLabel?.text = hallsoundViewModel?.type
            //            seatLabel?.text = tuple.direction.seatTitle
            audioImageView?.showImage(with: hallsoundViewModel?.image) { image in
                NotificationCenter.default.post(name: Notification.passHallSoundDetailViewModel, object: image)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func playPauseTapped(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.playAudioMiniPlayer, object: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.fastForwardAudioMiniPlayer, object: nil)
    }
    
    deinit {
        print("DEINIT-> \(self)")
        NotificationCenter.default.removeObserver(self)
    }
    
}

