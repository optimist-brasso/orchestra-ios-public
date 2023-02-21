//
//  FavouriteSessionCollectionViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 12/10/2022.
//

import UIKit

class FavouriteSessionCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    var viewModel: FavouriteViewModel? {
        didSet {
            setData()
        }
    }
    var unfavourite: (() -> Void)?
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView,
                                                       detailStackView,
                                                       favouriteButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.alignment = .top
        return stackView
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView(image: GlobalConstants.Image.placeholder)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier:  83 / 130).isActive = true 
//        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.contentMode = .scaleAspectFit
  //      imageView.curve = 8
        
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [orchestraDetailStackView,
                                                       playerDetailStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var orchestraDetailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       japaneseTitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "original recording"
        label.font = .appFont(type: .notoSansJP(.bold), size: .size13)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var japaneseTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ゲンバンヒョウキ"
        label.font = .appFont(type: .notoSansJP(.bold), size: .size13)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var playerDetailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [instrumentLabel,
                                                       playerLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var instrumentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ゲンバンヒョウキ"
        label.font = .appFont(type: .notoSansJP(.medium), size: .size13)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var playerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "original recording"
        label.font = .appFont(type: .notoSansJP(.medium), size: .size13)
        label.numberOfLines = .zero
        return label
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
        
        thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.35).isActive = true
        
        titleLabel.trailingAnchor.constraint(equalTo: detailStackView.trailingAnchor).isActive = true
        japaneseTitleLabel.trailingAnchor.constraint(equalTo: detailStackView.trailingAnchor).isActive = true
    }
    
    private func setData() {
        titleLabel.text = viewModel?.title
        japaneseTitleLabel.text = viewModel?.titleJapanese
        playerLabel.text = viewModel?.playerName
        playerLabel.isHidden = viewModel?.playerName?.isEmpty ?? true
        instrumentLabel.text = viewModel?.instrument
        instrumentLabel.isHidden = viewModel?.instrument?.isEmpty ?? true
        thumbnailImageView.contentMode = .scaleAspectFill
        favouriteButton.isSelected = viewModel?.isSessionFavourite ?? false
        
        thumbnailImageView.showImage(with: viewModel?.image, placeholderImage: GlobalConstants.Image.playerThumbnailSmall, transition: .crossDissolve(1)) { [weak self] image in
            guard let image = image, let self = self else {return}
            self.thumbnailImageView.contentMode = .top
            let width = self.thumbnailImageView.frame.size.width
            let photo = image.resized(width * 1.2)
            self.thumbnailImageView.image = photo
        }
    }
    
    @objc private func action(_ sender: UIButton) {
        unfavourite?()
    }
    
}
