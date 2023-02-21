//
//  PremiumVideoDetailsPlayerView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 30/06/2022.
//

import UIKit

class PremiumVideoDetailsPlayerView: UIView {
    
    //MARK: Properties
    var favourite: (() -> ())?
    
    //MARK: UI Properties
    private(set) lazy var playerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let thumnailRatio = GlobalConstants.AspectRatio.videoThumbnail
        view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: thumnailRatio.height / thumnailRatio.width).isActive = true
        view.backgroundColor = UIColor(hexString: "#C4C4C4")
        return view
    }()
    
    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [playImageView,
                                                       playLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private(set) lazy var playImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "play_white"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 47).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var playLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.playSampleVideo.value
        label.font = .notoSansJPBold(size: .size16)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var premiumLabel: UILabel = {
        let label = PaddingLabel(UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 28).isActive = true
        label.backgroundColor = UIColor(hexString: "#B2964E")
        label.font = .appFont(type: .notoSansJP(.regular), size: .size12)
        label.text = "PREMIUM"
        label.textColor = .white
        label.curve = 5
        return label
    }()
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        addSubview(playerView)
        playerView.fillSuperView()
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: playerView.centerYAnchor)
        ])
        
        playerView.addSubview(premiumLabel)
        NSLayoutConstraint.activate([
            premiumLabel.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: -9),
            premiumLabel.topAnchor.constraint(equalTo: playerView.topAnchor, constant: 11)
        ])
    }
    
//    @objc  private func buttonTapped(_ sender: UIButton) {
//        switch sender {
//        case favouriteButton:
//            favourite?()
//        case backButton:
//            back?()
//        default: break
//        }
//    }
    
}
