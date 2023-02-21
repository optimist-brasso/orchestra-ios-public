//
//  InstrumentPlayerViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 14/06/2022.
//
//

import UIKit
import AVKit
import AVFoundation
import Swifty360Player
import SwiftUI
import MobileVLCKit


class InstrumentPlayerViewController: UIViewController {
    
    struct Constant {
//        static let initialFov: Float = 40
        static let maximumFov: Float = 80
        static let minimumFov: Float = 20
        static let fullAccessMaximumFov: Float = 180
        static let zoomOutSpeed: CGFloat = 2.5
        static let maxHorizontalSwipeDistance: CGFloat = 5
        static let maxVerticalSwipeDistance: CGFloat = 1
        static let trialDuration: Int = 30
        static let appendixSampleTime: Int64 = 45
        static let sampleTime: Int64 = 30
    }

    // MARK: Properties
    @IBOutlet weak var topTrailingStackView: UIStackView!
    @IBOutlet weak var sampleTag: UIButton!
    @IBOutlet weak var premiumTag: UIButton!
    @IBOutlet weak var settingButton: UIButton!{
        didSet{
            settingButton.setImage(UIImage(named: "settings")?.withTintColor(.white), for: .normal)
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var japaneseTitleLabel: UILabel!
    @IBOutlet weak var instrumentLabel: UILabel!
    @IBOutlet weak var businessTypeLabel: UILabel!
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var runningTime: UILabel!
    @IBOutlet weak var totalDuration: UILabel!
    
    var duration:Int = 0
    var runningValue:Int = 0
    var isSeeking = true
    
    private var viewModel: InstrumentPlayerViewModel? {
        didSet {
            guard let url = viewModel?.videoURL else { return }
            if !isSetupCalled {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: { [weak self] in
                    self?.setData()
                    self?.setupVLCPlayer(url: url)
                })
                isSetupCalled = true
            }
        }
    }
    
    private var retakePopupView = RetakePopupView()
    let speed: Double = 1
    private var offsetDefaultTime: Int32 = 5
    private var isVideoPlaying: Bool = false
    private var isHideController: Bool = true {
        didSet {
//            if !isHideController {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
//                    self?.isHideController = true
//                }
//            }
            copyText += "\n\(isHideController)"
            UIPasteboard.general.string = copyText
            topTrailingStackView.isHidden = isHideController
            topView.isHidden = isHideController
            bottomView.isHidden = isHideController
        }
    }
    private var swifty360View: Swifty360View?
    private var timeObserver:Any?
    private var isVideoPlayed: Bool = false
    private var isSetupCalled: Bool = false
    private var timer: Timer?
    private var recordingDuration: Double = .zero
    private var finalRecordedDuration: Double = .zero
    private var avPlayer: AVPlayer!
    private var playerViewController: AVPlayerViewController!
    private var currentItem: AVPlayerItem?
    
    private var mediaPlayer = VLCMediaPlayer()
    
    private var yaw: Float = .zero
    private var pitch: Float = .zero
    private var roll: Float = .zero
    private var fov = Constant.maximumFov
//    private var range: CGFloat?
    private var previousScale: CGFloat = 1
    private var widthPerAngle: CGFloat = .zero
    private var heightPerAngle: CGFloat = .zero
    private var previousLocation: CGPoint = .zero
    
    var maxYaw: Float = 180
    var minYaw: Float = -180
    let maxPitch: Float = 60
    let minPitch: Float = -60

    var orchestraId: Int = .zero
    var sessionType: SessionType = .part
    var isPlayerNormal: Bool = false
    private var recordingManager = SoundRecordingManager()
    private var sampleTimePeriod: Int64 = 40
    private var counter: Int = 1
    var presenter: InstrumentPlayerModuleInterface?
    private var copyText = ""
    
    override func loadView() {
        super.loadView()
        fixOrientationTo(type: .landscapeRight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fixOrientationTo(type: .landscapeRight)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        addObserver()
        if mediaPlayer.isSeekable {
            clearPlayer()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fixOrientationTo(type: .portrait)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        recordingManager.stopRecording(with: false)
        timer?.invalidate()
        timer = nil
        recordingDuration = .zero
        NotificationCenter.default.removeObserver(self)
    }
    
    private func fixOrientationTo(type: UIInterfaceOrientation) {
        DispatchQueue.main.async {
            UIDevice.current.setValue(type.rawValue, forKey: "orientation")
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    private func setup() {
        setupSlider()
        setupGesture()
        calculatePerAngleValue()
        sampleTimePeriod = isPlayerNormal ? Constant.appendixSampleTime : Constant.sampleTime
        [sampleTag,
         premiumTag].forEach{
            $0.curve = 5
        }
        sampleTag.set(of: .white)
        isHideController = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    func setupVLCPlayer(url: String) {
        mediaPlayer.delegate = self
        mediaPlayer.drawable = playerView
        guard let url = URL(string: url) else {
            print("Error loading video url...")
            return
        }
        if UIDevice.current.orientation == .portrait {
            fixOrientationTo(type: .landscapeRight)
        }
        let media = VLCMedia(url: url)
        mediaPlayer.media = media
        playOrPause()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        playerView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        playerView.addGestureRecognizer(pinchGesture)
       
        
        let videoDuration = Int(mediaPlayer.media.length.intValue / 1000)
        duration = videoDuration
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
            self?.setupVideoDuration()
            self?.updateTimer()
        })
        
    }
    
    private func setupVideoDuration() {
        guard let isBought = sessionType == .premium && isPlayerNormal ? viewModel?.isPremiumBought : viewModel?.isPartBought else { return }
        let total = Int(mediaPlayer.media.length.intValue / 1000)
        duration = isBought ? total : Int(sampleTimePeriod)
        totalDuration.text = duration.time ?? ":"
    }
    
    private func updateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            let isBought = (self?.sessionType == .part ? self?.viewModel?.isPartBought : self?.viewModel?.isPremiumBought) ?? false
            guard let self = self,
                  let totalDuration = isBought ? self.mediaPlayer.media.length.stringValue : Int(self.sampleTimePeriod).time, let currentTime = self.mediaPlayer.time.stringValue else { return }
            if currentTime < totalDuration {
                self.totalDuration.text = totalDuration
                if self.mediaPlayer.isPlaying {
                    self.runningValue = Int(self.mediaPlayer.time.intValue / 1000)
                    self.runningTime.text = currentTime
                    if self.isSeeking {
                        self.slider.value = self.mediaPlayer.position
                    }
                }
            } else if currentTime == totalDuration || currentTime > totalDuration  {
                 self.clearPlayer()
            }
        }
    }

    private func calculatePerAngleValue() {
        let horizontalAxis: CGFloat = 180
        let width = UIScreen.main.bounds.width
        widthPerAngle = width / horizontalAxis
        let verticalAxis: CGFloat = 90
        let height = UIScreen.main.bounds.height
        heightPerAngle = height / verticalAxis
    }
    
    @objc private  func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let currentLocation = gestureRecognizer.location(in: view)
        if gestureRecognizer.state == .began {
            previousLocation = currentLocation
            if !isHideController {
                isHideController = true
            }
        }
        let diffX = currentLocation.x - previousLocation.x
        let diffY = currentLocation.y - previousLocation.y
        previousLocation = currentLocation
        let diffYaw = diffX / widthPerAngle
        let diffPitch = diffY / heightPerAngle
        yaw -= Float(diffYaw)
        pitch -= Float(diffPitch)
        checkRestrictedAngle()
        mediaPlayer.updateViewpoint(yaw, pitch: pitch, roll: roll, fov: fov, absolute: true)
    }
    
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .began && !isHideController {
            isHideController = true
        }
        var fov = self.fov
        if gesture.scale > previousScale {
            fov = fov - Float(gesture.scale)
        } else if gesture.scale < previousScale {
            fov = fov + Float((gesture.scale < 1 ? Constant.zoomOutSpeed : 1) * gesture.scale)
        }
        previousScale = gesture.scale
        checkPinchRestrictedAngle(fov)
//        if fov >= Constant.minimumFov && fov <= Constant.maximumFov {
//            self.fov = fov
//            checkHorizontallyRestrictedAngle()
//            mediaPlayer.updateViewpoint(yaw, pitch: pitch, roll: roll, fov: fov, absolute: true)
//        }
    }
    
    private func checkRestrictedAngle() {
        //vertical rotation restriction
        if pitch > maxPitch {
            pitch = maxPitch
        } else if pitch < minPitch {
            pitch = minPitch
        }
        
        //horizontal rotation restriction
        checkHorizontallyRestrictedAngle()
    }
    
    private func checkHorizontallyRestrictedAngle() {
        guard sessionType == .part,
              !(viewModel?.isPremiumBought ?? false),
              let viewAngleLeft = viewModel?.leftViewAngle,
              let viewAngleRight = viewModel?.rightViewAngle else { return }
        if Float(viewAngleLeft + viewAngleRight) >= (Float(360) - Constant.maximumFov) {
            return
        }
        
        if (Float(viewAngleLeft + viewAngleRight) < (360 - Constant.maximumFov)) {
//            let scale = Constant.maximumFov / fov
//            print("scale: \(scale)")
//            let difference = Constant.maximumFov - fov
//            let extraAngle = (Constant.maximumFov / 2) + (difference / scale)
//            minYaw = -(Float(viewAngleLeft) + extraAngle)
//            maxYaw = Float(viewAngleRight) + extraAngle
            minYaw = -Float(viewAngleLeft)
            maxYaw = Float(viewAngleRight)
//            minYaw = -(Float(viewAngleLeft) + (Constant.maximumFov / 2))
//            maxYaw = Float(viewAngleRight) + (Constant.maximumFov / 2)

        }
        if minYaw > yaw {
            yaw = minYaw
        } else if maxYaw < yaw {
            yaw = maxYaw
        }
    }
    
    private func checkPinchRestrictedAngle(_ fov: Float) {
        let leftViewAngle = viewModel?.leftViewAngle ?? .zero
        let rightViewAngle = viewModel?.rightViewAngle ?? .zero
        if sessionType == .premium ||
            viewModel?.isPremiumBought ?? false ||
            (Float(leftViewAngle + rightViewAngle) >= (Float(360) - Constant.maximumFov)) {
            if fov >= Constant.minimumFov && fov <= Constant.fullAccessMaximumFov {
                self.fov = fov
                checkHorizontallyRestrictedAngle()
                mediaPlayer.updateViewpoint(yaw, pitch: pitch, roll: roll, fov: fov, absolute: true)
            }
        } else {
            if fov >= Constant.minimumFov && fov <= Constant.maximumFov {
                self.fov = fov
                checkHorizontallyRestrictedAngle()
                mediaPlayer.updateViewpoint(yaw, pitch: pitch, roll: roll, fov: fov, absolute: true)
            }
        }
    }
    
    //angle restriction from center
//    private func checkHorizontallyRestrictedAngle() {
//        guard sessionType == .part,
//              !(viewModel?.isPremiumBought ?? false),
//              let viewAngleLeft = viewModel?.leftViewAngle,
//              let viewAngleRight = viewModel?.rightViewAngle else { return }
//        if viewAngleLeft + viewAngleRight >= 360 {
//            return
//        }
//
//        if (Float(viewAngleLeft + viewAngleRight) < 360) {
//            minYaw = -(Float(viewAngleLeft) - (fov / 2))
//            maxYaw = Float(viewAngleRight) - (fov / 2)
//        }
//        if minYaw > yaw {
//            yaw = minYaw
//        } else if maxYaw < yaw {
//            yaw = maxYaw
//        }
//    }

    private func setupGesture() {
        playerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleController)))
    }
    
    private func setSliderThumb(_ color: UIColor) {
        let circleImage = makeCircleWith(size: CGSize(width: 15, height: 15),
                                         backgroundColor: color)
        slider.setThumbImage(circleImage, for: .normal)
        slider.setThumbImage(circleImage, for: .highlighted)
    }

    func clearPlayer() {
        isVideoPlaying = false
        mediaPlayer.time = VLCTime(number: 0)
        mediaPlayer.position = .zero
        mediaPlayer.stop()
        playButton.setImage(UIImage(named: "play_white"), for: .normal)
        slider.value = .zero
        runningTime.text = "00:00"
        yaw = .zero
        pitch = .zero
        fov = Constant.maximumFov
        isHideController = false
        runningValue = .zero
        isSeeking = true
    }
    
    private func setData() {
        premiumTag.isHidden = sessionType != .premium
        titleLabel.text = viewModel?.title
        japaneseTitleLabel.text = viewModel?.japaneseTitle
        instrumentLabel.text = viewModel?.instrument
        businessTypeLabel.text = viewModel?.businessType
        businessTypeLabel.isHidden = viewModel?.businessType?.isEmpty ?? true
        
        let isBought = (sessionType == .part ? viewModel?.isPartBought : viewModel?.isPremiumBought) ?? false
        sampleTag.isHidden = isBought || (sessionType == .premium && viewModel?.isPartBought ?? false && !isPlayerNormal)
    }
    
    @IBAction func buttonBackward(_ sender: Any) {
        isSeeking = true
        if mediaPlayer.isPlaying {
            mediaPlayer.jumpBackward(offsetDefaultTime)
            return
        }
        updateSeekbar(isFast: false)
    }
    
    @IBAction func buttonForward(_ sender: Any) {
        isSeeking = true
        if mediaPlayer.isPlaying {
            mediaPlayer.jumpForward(offsetDefaultTime) 
            return
        }
        updateSeekbar(isFast: true)
    }
    
    func updateSeekbar(isFast: Bool = true) {
        let totalDuration = Int(mediaPlayer.media.length.intValue / 1000)
        let currentDuration = runningValue
        var value: Int = .zero
        
        if (currentDuration < Int(offsetDefaultTime)) && !isFast {
            value = .zero
            updateTime()
        } else if (currentDuration >= .zero) && (currentDuration < (duration - Int(offsetDefaultTime))) && isFast {
            value = currentDuration + Int(offsetDefaultTime)
            updateTime()
        } else if (currentDuration <= duration) && !isFast {
            value = currentDuration - Int(offsetDefaultTime)
            updateTime()
        }
        
        func updateTime() {
            runningValue = value
            runningTime.text = value.time
            slider.value = (Float(value) / Float(totalDuration))
        }
    }
    
    @IBAction func buttonSetting(_ sender: Any) {
        
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        clearPlayer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
            self?.presenter?.previousModule()
        })
    }
    
    @IBAction func buttonPlayPause(_ sender: Any) {
        playOrPause()
    }

    func playOrPause() {
        if mediaPlayer.isPlaying {
            mediaPlayer.pause()
        } else {
            mediaPlayer.play()
        }
        if runningValue != 0 {
            let totalDuration = Float(mediaPlayer.media.length.intValue / 1000)
            let position = (Float(runningValue) / totalDuration)
            mediaPlayer.position = position
        }
        playButton.setImage(UIImage(named: mediaPlayer.isPlaying ? "play_white" : "pause_white"), for: .normal)
    }
    
    private func changeRecordingStatusLabel(to text: String) {
        if recordingManager.isRecording {
        }
    }
    
    private func setupRecordingSound() {
        
    }
    
    private func setupSlider() {
        slider.addTarget(self, action:#selector(sliderValueDidChange(_:)), for: .valueChanged)
        slider.minimumValue = .zero
        slider.maximumValue = 1
        slider.tintColor = UIColor.white
        slider.isContinuous = false
        setSliderThumb(.white)
    }

    private func startAnimating() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    private func endAnimating() {
        activityIndicator.stopAnimating()
    }

    @objc private func appMovedToBackground() {
        mediaPlayer.pause()
        playButton.setImage(UIImage(named:"play_white"), for: .normal)
    }
    
    @objc private func appMovedToForeground() {
        fixOrientationTo(type: .landscapeRight)
        updateTimer()
    }
    
    @objc private func handleController() {
        isHideController.toggle()
    }
    
    @objc private func sliderValueDidChange(_ sender: UISlider) {
        let playTime = Float(duration) * sender.value
        runningValue = Int(playTime)
        isSeeking = false
        if playTime <= Float(duration - 1) {
            DispatchQueue.main.async { [weak self] in
                self?.slider.value = sender.value
                self?.slider.layoutIfNeeded()
                self?.mediaPlayer.position = Float(sender.value)
            }
            runningTime.text = Int(playTime).time
        } else {
            clearPlayer()
        }
    }
    
}

// MARK: InstrumentPlayerViewInterface
extension InstrumentPlayerViewController: InstrumentPlayerViewInterface {
    
    func show(_ model: InstrumentPlayerViewModel) {
        viewModel = model
    }
    
    func audioFileUploaded() {
        retakePopupView.removeFromSuperview()
        retakePopupView.hideLoader()
    }
    
    func endLoading() {
        retakePopupView.removeFromSuperview()
        retakePopupView.hideLoader()
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription, title: nil, okAction: { [weak self] in
            if error.localizedDescription == LocalizedKey.redownloadVideo.value {
                self?.presenter?.previousModule()
            }
        })
    }
    
}

extension InstrumentPlayerViewController {
    
    fileprivate func makeCircleWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, .zero)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}



extension InstrumentPlayerViewController: VLCMediaPlayerDelegate {
    
    // VLCMediaPlayerDelegate methods
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        
    }
    
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        // Handle changes in the player's state, such as starting or stopping playback
    }
    
}
