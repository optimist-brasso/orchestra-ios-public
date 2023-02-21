//
//  PurchasedContentListTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//

import UIKit

class PurchasedContentListTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: PurchasedContentListViewModel? {
        didSet {
            setData()
        }
    }
    
    var purchase: Purchasable! {
        didSet {
            configurationCell()
        }
    }
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageViewContainerView,
                                                       detailStackView,
                                                       moreButton])
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
        let label = PaddingLabel(UIEdgeInsets(top: .zero, left: 2, bottom: .zero, right: 2))
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
                                                       descriptionStackView,
                                                       timeLabel,
                                                       dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            descriptionLabel,
            instrumentLabel,
            
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "original recording"
        label.font = .appFont(type: .notoSansJP(.medium), size: .size13)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "ゲンバンヒョウキ"
        label.font = .appFont(type: .notoSansJP(.bold), size: .size14)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var instrumentLabel: UILabel = {
        let label = UILabel()
        label.text = "ゲンバンヒョウキ"
        label.font = .appFont(type: .notoSansJP(.bold), size: .size11)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "0:15:45"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size12)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "DATE　06/01/2022"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size13)
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
        //        button.setImage(GlobalConstants.Image.TabBar.favourite, for: .normal)
        button.tintColor = UIColor(hexString: "#6A6969")
        button.isHidden = true
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
        instrumentLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    private func setData() {
        thumbnailImageView.showImage(with: viewModel?.image)
        titleLabel.text = viewModel?.title
        descriptionLabel.text = viewModel?.titleJapanese
        descriptionLabel.isHidden = viewModel?.titleJapanese?.isEmpty ?? true
        timeLabel.text = viewModel?.duration
        timeLabel.isHidden = viewModel?.duration?.isEmpty ?? true
        durationLabel.text = viewModel?.duration
        durationLabel.isHidden = viewModel?.duration?.isEmpty ?? true
        dateLabel.text = "DATE \(viewModel?.releaseDate ?? "")"
        dateLabel.isHidden = viewModel?.releaseDate?.isEmpty ?? true
    }
    
    
    private func configurationCell() {
        
        switch purchase.title {
        case "hall sound":thumbnailImageView.showImage(with: purchase.image)
        case "part":thumbnailImageView.showImage(with: purchase.image)
        default:thumbnailImageView.showImage(with: purchase.image)
        }
        
        
        titleLabel.text = purchase.title
        descriptionLabel.text = purchase.titleJapanese
        descriptionLabel.isHidden = purchase.titleJapanese.isEmpty
        timeLabel.isHidden = true
        durationLabel.text = purchase.duration.time
        durationLabel.isHidden = purchase.duration.time?.isEmpty ?? true
        dateLabel.text = "DATE \(purchase.releaseDate)"
        dateLabel.isHidden = purchase.releaseDate.isEmpty
        instrumentLabel.isHidden = true
        if let value = purchase as? PurchasedPart {
            timeLabel.text =  value.instrumentTitle
            timeLabel.isHidden = value.instrumentTitle.isEmpty
        }
        if let value = purchase as? PurchasedPremium {
            timeLabel.text = value.instrumentTitle
            timeLabel.isHidden = value.instrumentTitle.isEmpty
        }
    }
    
}

class PurchaseHeader: UITableViewHeaderFooterView {
    
    private(set) lazy var titleLabel: PaddingLabel = {
        let label = PaddingLabel(UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 4))
        label.text = "original recording"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appFont(type: .notoSansJP(.medium), size: .size14)
        label.backgroundColor = .init(hexString: "#F6F6F6")
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func prepareLayout() {
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
