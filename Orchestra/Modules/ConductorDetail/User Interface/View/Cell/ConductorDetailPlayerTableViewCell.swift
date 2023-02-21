//
//  ConductorDetailPlayerTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 5/4/22.
//

import UIKit

class ConductorDetailPlayerTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var play: (() -> ())?
    var image: String?
    var vrFile: String? {
        didSet {
            playImageView.isHidden = vrFile?.isEmpty ?? true
            playerImageView.showImage(with: image)
        }
    }
    
    //MARK: UI Properties
    private lazy var playerImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let thumnailRatio = GlobalConstants.AspectRatio.videoThumbnail
        view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: thumnailRatio.height / thumnailRatio.width).isActive = true
        view.backgroundColor = UIColor(hexString: "#C4C4C4")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var playImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "play_white"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 47).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playVR)))
        return imageView
    }()
    
    private lazy var maximizeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "maximize"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        contentView.addSubview(playerImageView)
        playerImageView.fillSuperView()
        
        contentView.addSubview(playImageView)
        NSLayoutConstraint.activate([
            playImageView.centerXAnchor.constraint(equalTo: playerImageView.centerXAnchor),
            playImageView.centerYAnchor.constraint(equalTo: playerImageView.centerYAnchor)
        ])
    }
    
    @objc private func playVR() {
        play?()
    }
    
}
