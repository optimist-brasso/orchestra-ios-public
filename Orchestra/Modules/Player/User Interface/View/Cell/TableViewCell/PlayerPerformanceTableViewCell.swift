//
//  PlayerPerformanceTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//

import UIKit

class PlayerPerformanceTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: PlayerPerformanceViewModel? {
        didSet {
            setData()
        }
    }
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageViewContainerView, detailStackView, moreButton])
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
                                                       timeLabel,
                                                       dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "original recording"
        label.font = .appFont(type: .notoSansJP(.medium), size: .size13)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "ゲンバンヒョウキ"
        label.font = .appFont(type: .notoSansJP(.bold), size: .size14)
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
        stackView.fillSuperView(inset: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        
        imageViewContainerView.addSubview(thumbnailImageView)
        thumbnailImageView.fillSuperView()
        thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.43).isActive = true
        
        imageViewContainerView.addSubview(durationLabel)
        NSLayoutConstraint.activate([
            durationLabel.trailingAnchor.constraint(equalTo: imageViewContainerView.trailingAnchor, constant: -11),
            durationLabel.bottomAnchor.constraint(equalTo: imageViewContainerView.bottomAnchor, constant: -10),
        ])
    }
    
    private func setData() {
        thumbnailImageView.showImage(with: viewModel?.image)
        titleLabel.text = viewModel?.title
        descriptionLabel.text = viewModel?.titleJapanese
        descriptionLabel.isHidden = viewModel?.titleJapanese?.isEmpty ?? true
        durationLabel.text = viewModel?.duration
        timeLabel.text = viewModel?.duration
        dateLabel.text = "DATE \(viewModel?.releaseDate ?? "")"
        dateLabel.isHidden = viewModel?.releaseDate?.isEmpty ?? true
    }
    
}
