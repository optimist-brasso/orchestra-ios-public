//
//  InstrumentPlayerPopupScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import UIKit

class InstrumentPlayerPopupScreen: BaseScreen {
    
    //MARK: Properties
    var sessionType: SessionType = .premium {
        didSet {
            instrumentPlayerView.isHidden = sessionType != .part
            instrumentPlayerPremiumView.isHidden = sessionType != .premium
            switch sessionType {
            case .part:
                titleLabel.text = LocalizedKey.buyThisPart.value
            case .premium:
                titleLabel.text = LocalizedKey.buyBundlePremiumConfirmation.value
                whatButton.isHidden = sessionType == .premium
            default:
                break
            }
        }
    }
    var viewModel: InstrumentPlayerPopupViewModel? {
        didSet {
            instrumentPlayerView.viewModel = viewModel
            instrumentPlayerPremiumView.viewModel = viewModel
        }
    }
    var isAppendixVideo = false {
        didSet {
            instrumentPlayerPremiumView.isAppendixVideo = isAppendixVideo
        }
    }
    
    // MARK: UI Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(0.69)
        view.curve = 10
        return view
    }()
    
    private(set) lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(UIImage(named: "cross")?.withTintColor(.black), for: .normal)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.buyThisPart.value
        label.textColor = UIColor(hexString: "#6A6969")
        label.font = .notoSansJPRegular(size: .size16)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [instrumentPlayerView,
                                                       instrumentPlayerPremiumView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private(set) lazy var instrumentPlayerView: InstrumentPlayerView = {
        let view = InstrumentPlayerView()
        view.isHidden = sessionType != .part
        return view
    }()
    
    private(set) lazy var instrumentPlayerPremiumView: InstrumentPlayerPremiumPopupView = {
        let view = InstrumentPlayerPremiumPopupView()
        view.isHidden = sessionType != .premium
        view.isAppendixVideo = isAppendixVideo
        return view
    }()
    
    private(set) lazy var whatButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSAttributedString(string: LocalizedKey.whatIsPremiumVideo.value, attributes: [.foregroundColor : UIColor.black,
                                                                               NSAttributedString.Key.font: UIFont.notoSansJPRegular(size: .size12),
                                                                                                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        backgroundColor = .clear
        
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 40),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 51),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40)
//            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        containerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        ])
        
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -12),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 74),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 320)
        ])
        
        containerView.addSubview(whatButton)
        NSLayoutConstraint.activate([
            whatButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            whatButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
}
