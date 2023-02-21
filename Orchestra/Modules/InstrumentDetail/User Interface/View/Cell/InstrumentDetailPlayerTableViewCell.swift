//
//  InstrumentDetailPlayerTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 30/06/2022.
//

import UIKit

class InstrumentDetailPlayerTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: InstrumentDetailViewModel? {
        didSet {
//            if let url = URL(string: viewModel?.vrFile ?? ""), let thumbnailImage = url.thumbnailImage {
//                playerImageView.image = thumbnailImage
//            } else {
//                playerImageView.showImage(with: viewModel?.orchestra?.image)
//            }
            playerImageView.showImage(with: viewModel?.vrThumbnail)
            stackView.isHidden = viewModel?.vrFile?.isEmpty ?? true
            playLabel.text = (viewModel?.isBought ?? false ? LocalizedKey.playVideo : LocalizedKey.playSampleVideo).value
        }
    }
    var play: (() -> ())?
    
    //MARK: UI Properties
    private(set) lazy var playerImageView: UIImageView = {
        let view = UIImageView()
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
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playTapped)))
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
    
    private lazy var minusOneLabel: UILabel = {
        let label = PaddingLabel(UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 28).isActive = true
        label.backgroundColor = UIColor(hexString: "#0099C9")
        label.font = .appFont(type: .notoSansJP(.regular), size: .size12)
        label.text = "MinusOne"
        label.textColor = .white
        label.curve = 5
        return label
    }()
    
    //MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        contentView.addSubview(playerImageView)
        playerImageView.fillSuperView()
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
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: playerImageView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: playerImageView.centerYAnchor)
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
        
        contentView.addSubview(minusOneLabel)
        NSLayoutConstraint.activate([
            minusOneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -9),
            minusOneLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11)
        ])
    }
    
    @objc private func playTapped() {
        play?()
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
