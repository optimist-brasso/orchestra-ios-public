//
//  HallSoundAudioPlayerInteractor.swift
//  Orchestra
//
//  Created by rohit lama on 28/04/2022.
//
//

import Foundation
import AVFoundation
import CoreText
import MediaPlayer

class HallSoundAudioPlayerInteractor {
    
    //MARK: - Properties
    weak var output: HallSoundAudioPlayerInteractorOutput?
    private let service: HallSoundAudioPlayerServiceType
    private var player: AVAudioPlayer?
    private var timer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }
//    private var baseURL: String?
    private var playingInfo: [String: Any]?
//    private var image: String?
    private var type: String?
    
    //MARK: - Initialization
    init(service: HallSoundAudioPlayerServiceType) {
        self.service = service
    }

    //MARK: - Converting entities
    private func convert(_ model: HallSoundDetailViewModel, direction: HallSoundDirection) ->  HallSoundAudioPlayerStructure {
        playingInfo = [String: Any]()
        playingInfo?[MPMediaItemPropertyTitle] = model.title
        let hallsound = model.hallsounds?.element(at: direction.rawValue)
        return HallSoundAudioPlayerStructure(title: model.title,
                                             titleJapanese: model.titleJapanese,
                                             image: hallsound?.image,
                                             venueTitle: model.venue,
                                             seat: hallsound?.type)
    }
    
    //MARK: - Other Functions
    private func setupAudioPlayer(_ url: URL?, forced: Bool = false) {
        guard let url = url else {
            return
        }
        scheduleTimerForAudioUpdate()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = nil 
            player = try AVAudioPlayer(contentsOf: url)
            guard let hallSoundAudioPlayer = player else { return }
            getAudioTotalDuration()
            setupMediaPlayerNotificationView()
            hallSoundAudioPlayer.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
        playPauseAudio(forced: forced)
    }
    
    private func setUpNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(playAudio), name: Notification.playAudioMiniPlayer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(restartAudio), name: Notification.nextAudioMiniPlayer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(forwardAudioCurrentTime), name: Notification.fastForwardAudioMiniPlayer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupAudioPlayerWithURL(_:)), name: Notification.audioMiniPlayerURL, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(convertHallSoundDetailViewModel(_:)), name: Notification.passHallSoundDetailViewModel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePopUpViewControllerDismiss), name: Notification.dismissPopUpAudioMiniPlayer, object: nil)
    }
    
    private func setupMediaPlayerNotificationView() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.playPauseAudio()
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.playPauseAudio()
            return .success
        }
    }
    
    private func scheduleTimerForAudioUpdate() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgressOfAudio), userInfo: nil, repeats: true)
    }
    
    private func pauseTimerForAudioUpdate() {
        timer?.invalidate()
        timer = nil
    }
    
    private func setupAudioVolume(_ audioVolume: Float) {
        guard let hallSoundAudioPlayer = player else {
            return
        }
        hallSoundAudioPlayer.volume = audioVolume
    }
    
    private func getAudioTotalDuration() {
        guard let hallSoundAudioPlayer = player else {
            return
        }
        let audioDuration = Int(hallSoundAudioPlayer.duration).time
        output?.showAudioDuration(audioDuration)
        output?.syncAudioDurationAndSlider(Float(hallSoundAudioPlayer.duration))
    }
    
    @objc private func forwardAudioCurrentTime() {
        guard let hallSoundAudioPlayer = player else {
            return
        }
        if hallSoundAudioPlayer.currentTime < hallSoundAudioPlayer.duration {
            hallSoundAudioPlayer.currentTime += 10
        }
    }
    
    private func reverseAudioCurrentTime() {
        guard let hallSoundAudioPlayer = player else {
            return
        }
        if hallSoundAudioPlayer.currentTime < 10 {
            hallSoundAudioPlayer.currentTime = .zero
        } else {
            hallSoundAudioPlayer.currentTime -= 10
        }
    }
    
    private func syncAudioCurrentTimeWithAudioSliderValue(_ audioSliderValue: Float?) {
        guard let hallSoundAudioPlayer = player else {
            return
        }
        if let audioSliderValue = audioSliderValue {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
                hallSoundAudioPlayer.currentTime = Float64(audioSliderValue)
            }
        }
    }
    
    private func invalidatePlayer() {
        player?.stop()
        pauseTimerForAudioUpdate()
        player = nil
        output?.showPlayPauseStatus(false)
        NotificationCenter.default.post(name: Notification.audioPlayerPlayingStatus, object: false)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        output?.showAudioTimeElapsed("00:00")
        output?.syncAudioCurrentTimeAndSlider(.zero)
    }
    
    @objc private func playAudio(_ notification: Notification) {
        let status = notification.object as? Bool
        playPauseAudio(status)
    }
    
    private func playPauseAudio(_ status: Bool? = nil, forced: Bool = false) {
        guard let hallSoundAudioPlayer = player else {
            return
        }
        if let status = status {
            output?.showPlayPauseStatus(status)
            NotificationCenter.default.post(name: Notification.audioPlayerPlayingStatus, object: status)
            if status {
                hallSoundAudioPlayer.play()
                scheduleTimerForAudioUpdate()
            } else {
                hallSoundAudioPlayer.pause()
                pauseTimerForAudioUpdate()
            }
            return
        }
        if hallSoundAudioPlayer.isPlaying {
            hallSoundAudioPlayer.pause()
            pauseTimerForAudioUpdate()
            if forced {
                hallSoundAudioPlayer.stop()
                hallSoundAudioPlayer.currentTime = .zero
                hallSoundAudioPlayer.play()
                scheduleTimerForAudioUpdate()
            }
        } else {
            hallSoundAudioPlayer.play()
            scheduleTimerForAudioUpdate()
        }
        output?.showPlayPauseStatus(hallSoundAudioPlayer.isPlaying)
        NotificationCenter.default.post(name: Notification.audioPlayerPlayingStatus, object: hallSoundAudioPlayer.isPlaying)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = playingInfo
    }
    
    @objc private func restartAudio() {
//        forwardAudioCurrentTime()
        guard let hallSoundAudioPlayer = player else {
            return
        }
        if hallSoundAudioPlayer.isPlaying {
            hallSoundAudioPlayer.stop()
            pauseTimerForAudioUpdate()
        }
        hallSoundAudioPlayer.currentTime = .zero
//        hallSoundAudioPlayer.play()
        output?.showPlayPauseStatus(false)
        NotificationCenter.default.post(name: Notification.audioPlayerPlayingStatus, object: false)
    }
    
    @objc private func updateProgressOfAudio() {
        guard let hallSoundAudioPlayer = player else {
            return
        }
        let currentTimeString = hallSoundAudioPlayer.currentTime.stringFromTimeInterval()
//        let audioDuration = hallSoundAudioPlayer.duration.stringFromTimeInterval()
        if !hallSoundAudioPlayer.isPlaying {
            output?.showPlayPauseStatus(false)
            NotificationCenter.default.post(name: Notification.audioPlayerPlayingStatus, object: false)
//            restartAudio()
        }
        output?.showAudioTimeElapsed(currentTimeString)
        output?.syncAudioCurrentTimeAndSlider(Float(hallSoundAudioPlayer.currentTime))
    }
    
    @objc private func convertHallSoundDetailViewModel(_ notification: Notification?) {
        if let modelTuple = notification?.object as? (viewModel: HallSoundDetailViewModel, direction: HallSoundDirection) {
            output?.showAudioPlayerDetail(convert(modelTuple.viewModel, direction: modelTuple.direction))
        } else if let image = notification?.object as? UIImage {
            playingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { _ in
                return image
            })
        }
    }
    
    @objc private func handlePopUpViewControllerDismiss() {
        if let hallSoundAudioPlayer = player {
//            if hallSoundAudioPlayer.isPlaying {
//                hallSoundAudioPlayer.pause()
//            }
            hallSoundAudioPlayer.stop()
            pauseTimerForAudioUpdate()
        }
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("audioSession properties weren't disable.")
        }
        player = nil
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        timer?.invalidate()
    }
    
    @objc private func setupAudioPlayerWithURL(_ notification: Notification?) {
        if let urlNotificationTuple = notification?.object as? (url: String, type: String?) {
            if type != urlNotificationTuple.type {
//                image = urlNotificationTuple.image
                let baseURL = urlNotificationTuple.url
                type = urlNotificationTuple.type
//                playAudio()
                invalidatePlayer()
                if baseURL.starts(with: "file:///") {
                    setupAudioPlayer(URL(string: baseURL), forced: true)
                    return
                }
                let URL = URL(string: baseURL)
                guard let URL = URL else {
                    return
                }
                downloadFileFromURL(URL)
            } else {
                playPauseAudio(forced: true)
            }
        }
    }
    
    deinit {
        player?.stop()
        pauseTimerForAudioUpdate()
        player = nil
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK: - HallSoundAudioPlayer interactor input interface
extension HallSoundAudioPlayerInteractor: HallSoundAudioPlayerInteractorInput {
    
    func viewIsReady() {
        setUpNotificationObservers()
    }
    
    func playSong() {
        playPauseAudio()
    }
    
    func audioSliderScrubbed(_ audioSliderValue: Float?) {
        syncAudioCurrentTimeWithAudioSliderValue(audioSliderValue)
    }
    
    func forwardAudio() {
        forwardAudioCurrentTime()
    }
    
    func reverseAudio() {
        reverseAudioCurrentTime()
    }
    
}

extension HallSoundAudioPlayerInteractor {
    
    private func downloadFileFromURL(_ url: URL){
        var downloadTask: URLSessionDownloadTask?
        downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] (URL, response, error) -> Void in
            DispatchQueue.main.async { [weak self] in
                self?.setupAudioPlayer(URL)
            }
        }
        downloadTask?.resume()
    }
    
}
