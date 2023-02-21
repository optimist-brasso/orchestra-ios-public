//
//  FavouriteCollectionViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/04/2022.
//

import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell {
    
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
    
    public lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView(image: GlobalConstants.Image.placeholder)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 83 / 151).isActive = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var durationLabel: PaddingLabel = {
        let label = PaddingLabel(UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        label.backgroundColor = UIColor(hexString: "#262626")
        label.font = .appFont(type: .notoSansJP(.regular), size: .size12)
        label.text = "20: 00"
        label.textColor = .white
        return label
    }()
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       descriptionLabel,
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
        label.font = .appFont(type: .notoSansJP(.medium), size: .size13)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ゲンバンヒョウキ"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size11)
        label.numberOfLines = .zero
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
        return label
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favouriteButton, moreButton])
        return stackView
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.favourite, for: .normal)
        button.tintColor = UIColor(hexString: "#6A6969")
        button.tag = 0
        button.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 16).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.moreAction, for: .normal)
        button.tag = 1
        button.isHidden = true 
        return button
    }()
    
    var data: Favourite! {
        didSet {
            if data != nil {
                configurationCell()
            }
        }
    }
    
    var makeUnfavourite: ((_ id:Int, _ type: String) -> Void)?
    
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
        contentView.addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 8, left: 21, bottom: 8, right: 21))
        
        imageViewContainerView.addSubview(thumbnailImageView)
        thumbnailImageView.fillSuperView()
        thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.43).isActive = true
        
        imageViewContainerView.addSubview(durationLabel)
        NSLayoutConstraint.activate([
            durationLabel.trailingAnchor.constraint(equalTo: imageViewContainerView.trailingAnchor, constant: -11),
            durationLabel.bottomAnchor.constraint(equalTo: imageViewContainerView.bottomAnchor, constant: -10),
        ])
        
        titleLabel.trailingAnchor.constraint(equalTo: detailStackView.trailingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: detailStackView.trailingAnchor).isActive = true
    }
    
    private func configurationCell() {
        titleLabel.text = data.title
        descriptionLabel.text = data.jpTitle
        
        durationLabel.text = data.duration.time
        premiumLabel.isHidden = !(data.tags?.contains(where: {$0.lowercased() == "premium"}) ?? false)
        
        
    }
    
    @objc private func action(_ sender: UIButton) {
        if sender.tag == favouriteButton.tag {
            makeUnfavourite?(data.id, data.type)
        }
    }
    
}
