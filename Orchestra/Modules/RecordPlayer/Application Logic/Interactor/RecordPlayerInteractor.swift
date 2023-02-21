//
//  RecordPlayerInteractor.swift
//  Orchestra
//
//  Created by rohit lama on 11/05/2022.
//
//
import UIKit
import AVFoundation

class RecordPlayerInteractor {
    
    // MARK: Properties
    weak var output: RecordPlayerInteractorOutput?
    private let service: RecordPlayerServiceType
    private var player: AVAudioPlayer?
    private var timer: Timer?
    private var model: Recording?
    
    // MARK: Initialization
    init(service: RecordPlayerServiceType) {
        self.service = service
        setupNotificationObservers()
    }

    // MARK: Converting entities
    private func convert(_ model: Recording) -> RecordPlayerStructure {
        return RecordPlayerStructure(title: model.title,
                                     edition: model.edition,
                                     date: model.date,
                                     duration: ((model.duration ?? .zero) / 1000).time,
                                     image: model.image,
                                     path: model.path)
    }
    
    
    //MARK: - Other Functions
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(receivedData(_:)), name: Notification.Name(rawValue: "PlayRecordingInRecordPlayer"), object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    
    @objc private func appMovedToBackground() {
        player?.stop()
        output?.showIsPlaying(false)
    }
    
    @objc private func receivedData(_ notification: Notification?) {
        if let model = notification?.object as? Recording {
            self.model = model
        }
    }
    
    private func setupRecording() {
        if let model = model {
            output?.obtained(convert(model))
            let url = URL(string: model.path ?? "")
            guard let url = url else {
                return
            }
            downloadFileFromURL(url)
        }
    }
    
    private func setupAudioPlayer(_ url: URL?) {
        guard let url = url else {
            return
        }
        scheduleTimerForAudioUpdate()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(false)
            player = nil
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            getAudioTotalDuration()
            player.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
        playAudio()
    }
    
    private func playAudio() {
        guard let player = player else {
            return
        }
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        output?.showIsPlaying(player.isPlaying)
    }
    
    private func restartAudio() {
        guard let player = player else {
            return
        }
        if player.isPlaying {
            player.pause()
        }
        player.currentTime = 0
        playAudio()
    }
    
    private func getAudioTotalDuration() {
        guard let player = player else {
            return
        }
        let audioDuration = Int(player.duration).time ?? ""
        output?.showTotalDuration(audioDuration, Float(player.duration))
    }
    
    private func scheduleTimerForAudioUpdate() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(updateProgressOfAudio), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func updateProgressOfAudio() {
        guard let player = player else {
            return
        }
        let currentTimeString = player.currentTime.stringFromTimeInterval()
        let audioDuration = player.duration.stringFromTimeInterval()
        if currentTimeString == audioDuration {
            output?.showIsPlaying(false)
        }
        output?.showAudioCurrentTime(currentTimeString)
        output?.syncAudioAndSlider(Float(player.currentTime))
    }
    
    private func syncAudioCurrentTimeWithAudioSliderValue(_ audioSliderValue: Float) {
        guard let player = player else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
            player.currentTime = Float64(audioSliderValue)
        }
    }
    
    private func forwardAudioCurrentTime() {
        guard let player = player else {
            return
        }
        if player.currentTime == 0 && !player.isPlaying {
            return
        } else {
            if (player.currentTime < player.duration) && ((player.currentTime + 10) < player.duration) {
                    player.currentTime += 10
            } else {
                resetPlayer()
            }
        }
    }
    
    private func resetPlayer() {
        guard let player = player else {
            return
        }
        player.stop()
        output?.showIsPlaying(false)
        player.currentTime = 0
    }
    
    private func reverseAudioCurrentTime() {
        guard let player = player else {
            return
        }
        if player.currentTime < 10 {
            player.currentTime = 0
        } else {
            player.currentTime -= 10
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: RecordPlayer interactor input interface
extension RecordPlayerInteractor: RecordPlayerInteractorInput {
    
    func viewIsReady() {
       setupRecording()
    }
    
    func playRecording() {
        playAudio()
    }
    
    func audioSliderScrubbed(_ value: Float) {
        syncAudioCurrentTimeWithAudioSliderValue(value)
    }
    
    func forwardRecording() {
        forwardAudioCurrentTime()
    }
    
    func reverseRecording() {
        reverseAudioCurrentTime()
    }
    
    func viewWillDismiss() {
        if let player = player {
            player.stop()
        }
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("audioSession properties weren't disable.")
        }
        player = nil
        timer?.invalidate()
    }
    
}

extension RecordPlayerInteractor {
    
    //    private func downloadFileFromURL(_ url: URL) {
    //        var downloadTask: URLSessionDownloadTask?
    //        downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] (URL, response, error) -> Void in
    //            DispatchQueue.main.async {
    //                self?.setupAudioPlayer(URL)
    //            }
    //        }
    //        downloadTask?.resume()
    //    }
    //
    func downloadFileFromURL(_ url: URL)  {
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
        print(destinationUrl)
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")
            //                self.play(url: destinationUrl)
            DispatchQueue.main.async { [weak self] in
                self?.setupAudioPlayer(destinationUrl)
            }
        } else {
            // you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                guard let location = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                    //                        self.play(url: destinationUrl)
                    DispatchQueue.main.async { [weak self] in
                        self?.setupAudioPlayer(destinationUrl)
                    }
                    print("File moved to documents folder")
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }).resume()
        }
    }
    
}
