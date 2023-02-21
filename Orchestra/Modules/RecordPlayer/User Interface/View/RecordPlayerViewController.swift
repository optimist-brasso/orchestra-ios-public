//
//  RecordPlayerViewController.swift
//  Orchestra
//
//  Created by rohit lama on 11/05/2022.
//
//

import UIKit

class RecordPlayerViewController: UIViewController {
    
    // MARK: Properties
    var presenter: RecordPlayerModuleInterface?
    
    // MARK: IBOutlets
    @IBOutlet weak var audioSlider: UIAudioSlider?
    @IBOutlet weak var volumeSlider: UIVolumeSlider?
    @IBOutlet weak var playButton: UIButton?
    @IBOutlet weak var timeElapsedLabel: UILabel?
    @IBOutlet weak var audioDuration: UILabel?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var songNameLabel: UILabel?
    @IBOutlet weak var editionLabel: UILabel?
    @IBOutlet weak var originalNameLabel: UILabel?
    @IBOutlet weak var durationLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        volumeSlider?.activate()
        self.setup()
        presenter?.viewIsReady()
    }
    
    // MARK: IBActions
    @IBAction func didTapBackBtn(_ sender: Any) {
        presenter?.viewWillDimiss()
        dismiss(animated: false)
    }
    
    @IBAction func audioSliderScrubbed(_ sender: UISlider) {
        presenter?.audioSliderScrubbed(Float(sender.value))
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        presenter?.playRecording()
    }
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        presenter?.forwardRecording()
    }
    
    @IBAction func reverseButtonTapped(_ sender: Any) {
        presenter?.reverseRecording()
    }
    
    @IBAction func shareButtonTouched(_ sender: UIButton) {
        if let text = songNameLabel?.text {
          let  controller = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            present(controller, animated: true, completion: nil)
        }
    }
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupSliders()
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton
//        navigationItem.leadingTitle = LocalizedKey.myPage.value

//        let cartBarButtonItem = UIBarButtonItem(image: GlobalConstants.Image.cart, style: .plain, target: self, action: nil)
//        let notificationBarButtonItem = UIBarButtonItem(image: GlobalConstants.Image.notification, style: .plain, target: self, action: nil)
//        navigationItem.rightBarButtonItems = [cartBarButtonItem, notificationBarButtonItem]
    }
    
    private func setupData(_ model: RecordPlayerViewModel) {
        songNameLabel?.text = model.title
        imageView?.showImage(with: model.image)
        editionLabel?.text = model.edition
        durationLabel?.text = "LAP: " + (model.duration ?? "")
        durationLabel?.isHidden = model.duration?.isEmpty ?? true
        dateLabel?.text = "REC " + (model.date ?? "")
    }
    
    private func setupSliders() {
        audioSlider?.value = .zero
        audioSlider?.setThumbImage(UIImage(named: "Ellipse103"), for: .normal)
        volumeSlider?.setThumbImage(UIImage(named: "Ellipse102"), for: .normal)
        audioSlider?.minimumValue = .zero
    }
    
    private func setupPlayButton(_ isPlaying: Bool) {
        playButton?.setImage(isPlaying ? UIImage(systemName: "pause.circle.fill") : UIImage(systemName: "play.circle.fill") ,for: .normal)
        playButton?.contentMode = .scaleToFill
        playButton?.contentHorizontalAlignment = .fill
        playButton?.contentVerticalAlignment = .fill
    }
    
    private func setupVolume() {
        volumeSlider?.updatePositionForSystemVolume()
    }
    
    @objc private func backTapped() {
        presenter?.viewWillDimiss()
        dismiss(animated: false)
    }
    
    deinit {
        volumeSlider?.deactivate()
    }
    
}

// MARK: RecordPlayerViewInterface
extension RecordPlayerViewController: RecordPlayerViewInterface {
    
    func obtained(_ model: RecordPlayerViewModel) {
        //Other View Functions
        setupData(model)
    }
    
    func showIsPlaying(_ isPlaying: Bool) {
        setupPlayButton(isPlaying)
    }
    
    func showAudioCurrentTime(_ currentTime: String) {
        timeElapsedLabel?.text = currentTime
    }
    
    func syncAudioAndSlider(_ currentTime: Float) {
        audioSlider?.value = currentTime
    }
    
    func showTotalDuration(_ durationString: String, _ durationFloat: Float) {
        audioSlider?.maximumValue = durationFloat
        audioDuration?.text = durationString
    }
    
}
