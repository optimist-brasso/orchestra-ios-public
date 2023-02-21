//
//  PlaylistTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var type: OrchestraType = .conductor
    var viewModel: PlaylistViewModel? {
        didSet {
            setData()
        }
    }
    var favourite: (() -> Void)?
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageViewContainerView,
                                                       detailStackView,
                                                       actionStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.alignment = .top
        return stackView
    }()
    
    private lazy var imageViewContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.curve = 2
        view.backgroundColor = UIColor(hexString: "#C4C4C4", alpha: 0.5)
        return view
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView(image: GlobalConstants.Image.placeholder)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 83 / 151).isActive = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var durationLabel: PaddingLabel = {
        let label = PaddingLabel(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        label.backgroundColor = UIColor(hexString: "#262626")
        label.font = .appFont(type: .notoSansJP(.regular), size: .size12)
        label.text = "20: 00"
        label.textColor = .white
        return label
    }()
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       japaneseTitleLabel,
                                                       premiumLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "original recording"
        label.numberOfLines = .zero
        label.font = .appFont(type: .notoSansJP(.medium), size: .size13)
        return label
    }()
    
    private lazy var japaneseTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ゲンバンヒョウキ"
        label.numberOfLines = .zero
        label.font = .appFont(type: .notoSansJP(.regular), size: .size11)
        return label
    }()
    
    private lazy var premiumLabel: UILabel = {
        let label = PaddingLabel(UIEdgeInsets(top: 4, left: 15, bottom: 4, right: 15))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        label.backgroundColor = UIColor(hexString: "#B2964E")
        label.font = .appFont(type: .notoSansJP(.regular), size: .size12)
        label.text = "PREMIUM"
        label.textColor = .white
        label.curve = 2
        label.isHidden = true
        return label
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favouriteButton,
                                                       moreButton])
        return stackView
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = FavouriteButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.tintColor = UIColor(hexString: "#6A6969")
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 16).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.moreAction, for: .normal)
        button.isHidden = true
        return button
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
        contentView.addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 8, left: 21, bottom: 8, right: 16))
        
        imageViewContainerView.addSubview(thumbnailImageView)
        thumbnailImageView.fillSuperView()
        thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.43).isActive = true
        
        imageViewContainerView.addSubview(durationLabel)
        NSLayoutConstraint.activate([
            durationLabel.trailingAnchor.constraint(equalTo: imageViewContainerView.trailingAnchor, constant: -11),
            durationLabel.bottomAnchor.constraint(equalTo: imageViewContainerView.bottomAnchor, constant: -10),
        ])
        
        titleLabel.trailingAnchor.constraint(equalTo: detailStackView.trailingAnchor).isActive = true
        japaneseTitleLabel.trailingAnchor.constraint(equalTo: detailStackView.trailingAnchor).isActive = true
    }
    
    private func setData() {
      
        titleLabel.text = viewModel?.title
        japaneseTitleLabel.text = viewModel?.titleJapanese
        japaneseTitleLabel.isHidden = viewModel?.titleJapanese?.isEmpty ?? true
//        premiumLabel.isHidden = !(viewModel?.isPremium ?? false)
        durationLabel.text = viewModel?.duration
        durationLabel.isHidden = viewModel?.duration?.isEmpty ?? true
        favouriteButton.isHidden = type == .session
        var isFavourite = false
        switch type {
        case .conductor:
            isFavourite = viewModel?.isConductorFavourite ?? false
            thumbnailImageView.showImage(with: viewModel?.conductorImage)
        case .session:
            isFavourite = viewModel?.isSessionFavourite ?? false
            thumbnailImageView.showImage(with: viewModel?.image)
        case .hallSound:
            isFavourite = viewModel?.isHallSoundFavourite ?? false
            thumbnailImageView.showImage(with: viewModel?.venueDiagram)
        case .player:
            break
        }
        favouriteButton.isSelected = isFavourite
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        favourite?()
    }
    
}
