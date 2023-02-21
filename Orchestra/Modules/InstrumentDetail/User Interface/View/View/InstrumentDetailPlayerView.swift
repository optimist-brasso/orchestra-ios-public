//
//  InstrumentDetailPlayerView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 23/06/2022.
//

import UIKit

class InstrumentDetailPlayerView: UIView {
    
    //MARK: Properties
    var favourite: (() -> ())?
    var back: (() -> ())?
    
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
    
    private(set) lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(UIImage(named: "arrow_back")?.withTintColor(.white), for: .normal)
//        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
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
//        NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            stackView.topAnchor.constraint(equalTo: topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
//        ])
//        NSLayoutConstraint.activate([
//            playerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
//            detailStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 32)
//        ])
        
//        addSubview(favouriteButton)
//        NSLayoutConstraint.activate([
//            favouriteButton.widthAnchor.constraint(equalToConstant: 20),
//            favouriteButton.heightAnchor.constraint(equalTo: favouriteButton.widthAnchor),
//            favouriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            favouriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 8)
//        ])
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: playerView.centerYAnchor)
        ])
        
        addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 14)
        ])
        
//        bottomView.addSubview(actionStackView)
//        NSLayoutConstraint.activate([
//            actionStackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
//            actionStackView.topAnchor.constraint(equalTo: bottomView.topAnchor),
//            actionStackView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor)
//        ])
//
//        bottomView.addSubview(organizationChartButton)
//        NSLayoutConstraint.activate([
//            organizationChartButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
//            organizationChartButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
//        ])
        
//        bottomView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -13).isActive = true
        
//        addSubview(lineSeparatorView)
//        NSLayoutConstraint.activate([
//            lineSeparatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            lineSeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            lineSeparatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
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
