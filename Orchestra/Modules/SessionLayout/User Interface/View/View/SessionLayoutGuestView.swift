//
//  SessionLayoutGuestView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/06/2022.
//

import UIKit

class SessionLayoutGuestView: UIView {
    
    //MARK: Properties
    var viewModel: SessionLayoutViewModel? {
        didSet {
            thumbnailImageView.contentMode = .scaleAspectFill
            let imageView = UIImageView()
            thumbnailImageView.startIndicator()
            thumbnailImageView.backgroundColor = UIColor(hexString: "#C4C4C4")
            thumbnailImageView.image = nil
            imageView.showImage(with: viewModel?.instrument?.playerImage, placeholderImage: GlobalConstants.Image.playerThumbnailSmall) { [weak self] image in
                guard  let self = self else {return}
                guard let image = image else  {
                    self.updateThumbnail()
                    return
                }
                self.thumbnailImageView.contentMode = .top
                let width = self.thumbnailImageView.frame.size.width
                let photo = image.resized(width * 1.5)
                self.thumbnailImageView.image = photo
                self.thumbnailImageView.backgroundColor = .clear
                self.thumbnailImageView.stopIndicator()
            }
            if viewModel?.instrument?.playerImage == nil {
                 updateThumbnail()
            }
            instrumentLabel.text = viewModel?.instrument?.name
            playerNameLabel.text = viewModel?.instrument?.player
            descriptionLabel.text = viewModel?.instrument?.description
            descriptionLabel.isHidden = viewModel?.instrument?.description?.isEmpty ?? true
        }
    }
    var proceed: (() -> ())?
    
    //MARK: UI Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#262626").withAlphaComponent(0.8)
        view.curve = 4
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView,
                                                      textStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .top
        stackView.spacing = 30
        return stackView
    }()
    
    private lazy var thumbnailImageView: PlayerImage = {
        let imageView = PlayerImage(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 123).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 145).isActive = true
        imageView.backgroundColor = UIColor(hexString: "#C4C4C4")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [instrumentLabel,
                                                      playerNameLabel,
                                                      descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var instrumentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.text = "ハープ"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size18)
        label.textColor = .white
        return label
    }()
    
    private lazy var playerNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.text = "奏者名"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size18)
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "ここには紹介文が入ります。ここには紹介文が入ります。"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size18)
        label.textColor = .white
        return label
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 15).isActive = true
        button.setTitle(LocalizedKey.cancel.value, for: .normal)
        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nextButton,
                                                       nextImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizedKey.next.value, for: .normal)
        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "next"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        return imageView
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
        addSubview(containerView)
        containerView.fillSuperView()
        
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 36)
        ])
        
        containerView.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            bottomView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 36),
            bottomView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        bottomView.addSubview(seperatorView)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            seperatorView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            seperatorView.topAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
        
        bottomView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 36),
            cancelButton.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: 9),
            cancelButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -18)
        ])
        
        bottomView.addSubview(nextStackView)
        NSLayoutConstraint.activate([
            nextStackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -18),
            nextStackView.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor)
        ])
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case nextButton:
            proceed?()
        case cancelButton:
            isHidden = true
        default: break
        }
    }
    
    private func updateThumbnail() {
        thumbnailImageView.backgroundColor = UIColor(hexString: "#C4C4C4")
        thumbnailImageView.stopIndicator()
        thumbnailImageView.image = GlobalConstants.Image.playerThumbnailSmall
    }
    
}
