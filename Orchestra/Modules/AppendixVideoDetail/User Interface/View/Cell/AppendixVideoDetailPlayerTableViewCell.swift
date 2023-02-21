//
//  IndexVideoDetailPlayerTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//

import UIKit

class AppendixVideoDetailPlayerTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: AppendixVideoDetailViewModel? {
        didSet {
            playerImageView.showImage(with: viewModel?.thumbnail)
            stackView.isHidden = viewModel?.file?.isEmpty ?? true
            playLabel.text = ((viewModel?.isBought ?? false && viewModel?.isPartBought ?? false) ? LocalizedKey.playVideo : LocalizedKey.playSampleVideo).value
        }
    }
    var play: (() -> ())?
    
    //MARK: UI Properties
    private(set) lazy var playerImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let thumnailRatio = GlobalConstants.AspectRatio.videoThumbnail
        view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: thumnailRatio.height / thumnailRatio.width).isActive = true
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
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
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: playerImageView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: playerImageView.centerYAnchor)
        ])
        
        contentView.addSubview(premiumLabel)
        NSLayoutConstraint.activate([
            premiumLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -9),
            premiumLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11)
        ])
    }
    
    @objc private func playTapped() {
        play?()
    }
    
}
