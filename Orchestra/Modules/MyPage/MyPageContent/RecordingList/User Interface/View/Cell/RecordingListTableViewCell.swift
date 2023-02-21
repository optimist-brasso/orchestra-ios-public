//
//  RecordingListTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//

import UIKit

class RecordingListTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: RecordingListViewModel? {
        didSet {
            setData()
        }
    }
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageViewContainerView, trailingStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
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
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.songName.value
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.font = .appFont(type: .notoSansJP(.regular), size: .size24)
        label.textColor = UIColor(hexString: "#FF44E1")
        label.isHidden = true
        return label
    }()
    
    private lazy var trailingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [detailContainerView, moreButton])
        stackView.spacing = 4
        stackView.alignment = .top
        return stackView
    }()
    
    private lazy var detailContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    private lazy var detailStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [titleStackView])
//        stackView.axis = .vertical
//        return stackView
//    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "edition"
        label.isHidden = true
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "12345678901234567890abcdeabcdeabcdeabcdee"
        label.font = .appFont(type: .notoSansJP(.bold), size: .size14)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLabel,
                                                       dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "0:15:45"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "REC　06/01/2022"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 16).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.moreAction, for: .normal)
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
        stackView.fillSuperView(inset: UIEdgeInsets(top: 8, left: 21, bottom: 8, right: 21))
        
        imageViewContainerView.addSubview(thumbnailImageView)
        thumbnailImageView.fillSuperView()
        thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.35).isActive = true
        
        imageViewContainerView.addSubview(placeholderLabel)
        placeholderLabel.fillSuperView(inset: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        detailContainerView.addSubview(titleStackView)
        NSLayoutConstraint.activate([
            titleStackView.leadingAnchor.constraint(equalTo: detailContainerView.leadingAnchor),
            titleStackView.centerXAnchor.constraint(equalTo: detailContainerView.centerXAnchor),
            titleStackView.topAnchor.constraint(equalTo: detailContainerView.topAnchor)
        ])
        
        detailContainerView.addSubview(timeStackView)
        NSLayoutConstraint.activate([
            timeStackView.leadingAnchor.constraint(equalTo: detailContainerView.leadingAnchor),
            timeStackView.centerXAnchor.constraint(equalTo: detailContainerView.centerXAnchor),
            timeStackView.topAnchor.constraint(greaterThanOrEqualTo: titleStackView.bottomAnchor, constant: 16),
            timeStackView.bottomAnchor.constraint(equalTo: detailContainerView.bottomAnchor)
        ])
        
        detailContainerView.bottomAnchor.constraint(greaterThanOrEqualTo: imageViewContainerView.bottomAnchor).isActive = true
    }
    
    private func setData() {
        thumbnailImageView.showImage(with: viewModel?.image)
//        placeholderLabel.text = viewModel?.title
//        placeholderLabel.isHidden = viewModel?.title?.isEmpty ?? true
        descriptionLabel.text = viewModel?.title
//        let duration: String = String(viewModel?.duration ?? 0)
        timeLabel.text = viewModel?.duration
        timeLabel.isHidden = viewModel?.duration?.isEmpty ?? true
        dateLabel.text = viewModel?.date
        dateLabel.isHidden = viewModel?.date?.isEmpty ?? true
    }
    
}
