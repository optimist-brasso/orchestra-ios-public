//
//  InstrumentPlayerScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 14/06/2022.
//
//

import UIKit
import Swifty360Player

class InstrumentPlayerScreen: BaseScreen {
    
    //MARK: Properties
    var viewModel: InstrumentPlayerViewModel? {
        didSet {
            setData()
        }
    }
    var sessionType: SessionType = .part {
        didSet {
            premiumLabel.isHidden = sessionType != .premium
//            recordView.isHidden = sessionType != .part
            switch sessionType {
            case .part:
                [titleLabel,
                japaneseTitleLabel,
                 instrumentLabel].forEach({
                    $0.font = .notoSansJPMedium(size: .size16)
                })
            case .premium:
                titleLabel.font = .appFont(type: .notoSansJP(.light), size: .size16)
                japaneseTitleLabel.font = .appFont(type: .notoSansJP(.light), size: .size20)
                instrumentLabel.font = .appFont(type: .notoSansJP(.light), size: .size18)
                businessTypeLabel.font = .appFont(type: .notoSansJP(.light), size: .size12)
            default:
                break
            }
        }
    }
    var isAppendixVideo = false
    let recordSign = RecordCircleView()
    let recordingStatusLabel = UILabel()
    
    // MARK: UI Properties
    lazy var playerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor(hexString: "#C9C4CA")
        view.backgroundColor = .black
        return view
    }()
    
    private(set) lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topLeadingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView,
                                                       instrumentLabel,
                                                       businessTypeLabel,
                                                       sampleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       japaneseTitleLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "original recording"
        label.font = .notoSansJPMedium(size: .size16)
        label.numberOfLines = .zero
        label.textColor = .white
        return label
    }()

    private lazy var japaneseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "ゲンバンヒョウキハープ"
        label.font = .notoSansJPMedium(size: .size16)
        label.numberOfLines = .zero
        label.textColor = .white
        return label
    }()
    
    private lazy var instrumentLabel: UILabel = {
        let label = UILabel()
        label.text = "B♭トランペット"
        label.font = .notoSansJPMedium(size: .size16)
        label.numberOfLines = .zero
        label.textColor = .white
        return label
    }()
    
    private lazy var businessTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "R2 事業再構築"
        label.font = .notoSansJPMedium(size: .size16)
        label.numberOfLines = .zero
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    private lazy var sampleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.text = "SAMPLE"
        label.font = .notoSansJPMedium(size: .size18)
        label.textAlignment = .center
        label.textColor = .white
        label.curve = 5
        label.set(of: .white)
        return label
    }()

//    private lazy var appNameLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "BRASSO"
////        label.textColor = .black.withAlphaComponent(0.5)
//        label.font = .notoSansJPBold(size: .size24)
//        label.textColor = .white
//        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        return label
//    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "BrassoWhite"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 135).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return imageView
    }()
    
    private(set) lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(UIImage(named: "cross")?.withTintColor(.white), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
//        button.backgroundColor = .red
//        button.configuration = UIButton.Configuration.plain()
//        button.configuration?.imagePadding = .zero
        return button
    }()
    
    private lazy var premiumLabel: UILabel = {
        let label = PaddingLabel(UIEdgeInsets(top: 8, left: 22, bottom: 8, right: 22))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 28).isActive = true
        label.backgroundColor = UIColor(hexString: "#B2964E")
        label.font = .appFont(type: .notoSansJP(.regular), size: .size18)
        label.text = "PREMIUM"
        label.textColor = .white
        label.curve = 5
        return label
    }()
    
    private(set) lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 28).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(UIImage(named: "settings")?.withTintColor(.white), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private lazy var topRightStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recordingView,
                                                       premiumLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var recordingView: UIView = {
       let v = UIView()
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.heightAnchor.constraint(equalToConstant: 30),
            v.widthAnchor.constraint(equalToConstant: 70)
        ])

        recordingStatusLabel.text = "REC"
        recordingStatusLabel.font = .appFont(type: .notoSansJP(.light), size: .size18)
        recordingStatusLabel.textColor = .red
        recordingStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(recordingStatusLabel)
        NSLayoutConstraint.activate([
            recordingStatusLabel.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            recordingStatusLabel.centerYAnchor.constraint(equalTo: v.centerYAnchor),
        ])
        recordSign.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(recordSign)
        NSLayoutConstraint.activate([
            recordSign.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            recordSign.trailingAnchor.constraint(equalTo: recordingStatusLabel.leadingAnchor, constant: -8),
            recordSign.heightAnchor.constraint(equalToConstant: 30),
            recordSign.widthAnchor.constraint(equalToConstant: 30)
        ])
        return v
    }()
    
    private(set) lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var slider: UIAudioSlider = {
        let slider = UIAudioSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.heightAnchor.constraint(equalToConstant: 8).isActive = true
        slider.maximumTrackTintColor = UIColor(hexString: "#757575")
        return slider
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [slider,
                                                       actionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var actionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var buyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizedKey.buy.value, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 117).isActive = true
        button.heightAnchor.constraint(equalToConstant: 34).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size13)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hexString: "#DF0000")
//        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.curve = 5
        button.isHidden = true
        return button
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftActionStackView,
                                                       playButton,
                                                       rightActionStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var leftActionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
                                                       backwardButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    private(set) lazy var previousButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(UIImage(named: "player_prev"), for: .normal)
        return button
    }()
    
    private(set) lazy var backwardButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(UIImage(named: "backward"), for: .normal)
        return button
    }()
    
    private(set) lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 38).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(UIImage(named: "play_white"), for: .normal)
        return button
    }()
    
    private lazy var rightActionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [forwardButton
                                                       ])
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    private(set) lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(UIImage(named: "player_next"), for: .normal)
        return button
    }()
    
    private(set) lazy var forwardButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(UIImage(named: "forward"), for: .normal)
        return button
    }()
    
//    private lazy var recordView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.widthAnchor.constraint(equalToConstant: 93).isActive = true
//        view.heightAnchor.constraint(equalToConstant: 34).isActive = true
//        view.set(of: UIColor(hexString: "#CF0000"))
//        view.curve = 7
//        return view
//    }()
    
    private(set) lazy var recordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 93).isActive = true
        button.heightAnchor.constraint(equalToConstant: 34).isActive = true
        button.setTitle(LocalizedKey.rec.value, for: .normal)
        button.titleLabel?.font = .notoSansJPRegular(size: .size13)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hexString: "#DF0000")
        button.isHidden = true
        button.curve = 5
        //        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private(set) lazy var startDurationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0:00"
        label.font = .notoSansJPRegular(size: .size12)
        label.textColor = .white
        return label
    }()
    
    private(set) lazy var endDurationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.font = .notoSansJPRegular(size: .size12)
        label.textColor = .white
        return label
    }()
    
    private(set) lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        addSubview(playerView)
        playerView.fillSuperView()
        
        addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
//        titleView.addSubview(appNameLabel)
//        NSLayoutConstraint.activate([
//            appNameLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
//            appNameLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 20)
//        ])
        
        titleView.addSubview(topLeadingStackView)
        NSLayoutConstraint.activate([
            topLeadingStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 28),
            topLeadingStackView.trailingAnchor.constraint(equalTo: centerXAnchor),
            topLeadingStackView.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 20)
        ])
        
        titleView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -14),
            closeButton.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 10)
        ])
        
        titleView.addSubview(settingsButton)
        NSLayoutConstraint.activate([
            settingsButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -23),
            settingsButton.topAnchor.constraint(equalTo: closeButton.topAnchor),
            settingsButton.bottomAnchor.constraint(greaterThanOrEqualTo: titleView.bottomAnchor)
        ])
        
        titleView.addSubview(topRightStackView)
        NSLayoutConstraint.activate([
            topRightStackView.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -14),
            topRightStackView.topAnchor.constraint(equalTo: settingsButton.topAnchor)
        ])
        
//        titleView.addSubview(recordingView)
//        NSLayoutConstraint.activate([
//            recordingView.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor),
//            recordingView.heightAnchor.constraint(equalToConstant: 30),
//            recordingView.widthAnchor.constraint(equalToConstant: 70),
//            recordingView.topAnchor.constraint(equalTo: closeButton.topAnchor),
//        ])
        
//        titleView.addSubview(premiumLabel)
//        NSLayoutConstraint.activate([
//            premiumLabel.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -14),
//            premiumLabel.topAnchor.constraint(equalTo: settingsButton.topAnchor)
//        ])
        
        addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        bottomView.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -21),
            logoImageView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -8)
        ])
        
        bottomView.addSubview(bottomStackView)
        NSLayoutConstraint.activate([
            bottomStackView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 68),
            bottomStackView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            bottomStackView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 2),
            bottomStackView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -11)
        ])
        
        actionView.addSubview(actionStackView)
        NSLayoutConstraint.activate([
            actionStackView.centerXAnchor.constraint(equalTo: actionView.centerXAnchor),
            actionStackView.topAnchor.constraint(equalTo: actionView.topAnchor),
            actionStackView.bottomAnchor.constraint(equalTo: actionView.bottomAnchor),
        ])
        
        actionView.addSubview(buyButton)
        NSLayoutConstraint.activate([
            buyButton.trailingAnchor.constraint(equalTo: actionStackView.leadingAnchor, constant: -43),
            buyButton.topAnchor.constraint(equalTo: actionView.topAnchor)
        ])
        
//        recordView.addSubview(recordButton)
//        recordButton.fillSuperView()
//
//        actionView.addSubview(recordView)
//        NSLayoutConstraint.activate([
//            recordView.leadingAnchor.constraint(equalTo: actionStackView.trailingAnchor, constant: 50),
//            recordView.topAnchor.constraint(equalTo: actionView.topAnchor)
//        ])
        actionView.addSubview(recordButton)
        NSLayoutConstraint.activate([
            recordButton.leadingAnchor.constraint(equalTo: actionStackView.trailingAnchor, constant: 50),
            recordButton.topAnchor.constraint(equalTo: actionView.topAnchor)
        ])
        
        actionView.addSubview(startDurationLabel)
        NSLayoutConstraint.activate([
            startDurationLabel.leadingAnchor.constraint(lessThanOrEqualTo: actionView.leadingAnchor, constant: 8),
            startDurationLabel.topAnchor.constraint(equalTo: actionView.topAnchor),
            startDurationLabel.trailingAnchor.constraint(lessThanOrEqualTo: buyButton.leadingAnchor, constant: -8)
        ])
        
        actionView.addSubview(endDurationLabel)
        NSLayoutConstraint.activate([
            endDurationLabel.trailingAnchor.constraint(greaterThanOrEqualTo: actionView.trailingAnchor, constant: -8),
            endDurationLabel.topAnchor.constraint(equalTo: actionView.topAnchor),
            endDurationLabel.leadingAnchor.constraint(greaterThanOrEqualTo: recordButton.trailingAnchor, constant: 8)
        ])
        
        playerView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: playerView.centerYAnchor)
        ])
    }
    
    private func setData() {
        titleLabel.text = viewModel?.title
        japaneseTitleLabel.text = viewModel?.japaneseTitle
        instrumentLabel.text = viewModel?.instrument
        buyButton.setTitle((viewModel?.isPartBought ?? false ? LocalizedKey.buyPremium : LocalizedKey.buy).value, for: .normal)
        let isBought = (sessionType == .part ? viewModel?.isPartBought : viewModel?.isPremiumBought) ?? false
        sampleLabel.isHidden = isBought || (sessionType == .premium && viewModel?.isPartBought ?? false && !isAppendixVideo)
//        buyButton.isHidden = viewModel?.isPartBought ?? false && viewModel?.isPremiumBought ?? false
        businessTypeLabel.text = viewModel?.businessType
        businessTypeLabel.isHidden = viewModel?.businessType?.isEmpty ?? true
    }
    
}

