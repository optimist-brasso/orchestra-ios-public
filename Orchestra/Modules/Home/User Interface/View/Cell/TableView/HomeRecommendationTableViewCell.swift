//
//  HomeRecommendationTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//

import UIKit

class HomeRecommendationTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: HomeRecommendationViewModel? {
        didSet {
            setData()
        }
    }
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageViewContainerView,
                                                       detailContainerView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.alignment = .top
        return stackView
    }()
    
    private lazy var imageViewContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#C4C4C4", alpha: 0.5)
        view.curve = 8
        return view
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView(image: GlobalConstants.Image.placeholder)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 117 / 174).isActive = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var tagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var tagsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var firstIndicatorLabel: PaddingLabel = {
        let label = PaddingLabel(UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        label.backgroundColor = .appGreen
        label.font = .appFont(type: .notoSansJP(.regular), size: .size11)
        label.curve = 4
        label.text = "NEW"
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    private lazy var secondIndicatorLabel: PaddingLabel = {
        let label = PaddingLabel(UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        label.backgroundColor = .appGreen
        label.font = .appFont(type: .notoSansJP(.regular), size: .size11)
        label.curve = 4
        label.text = "NEW"
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    private lazy var detailContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       japaneseTitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "見出しコピー"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size16)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var japaneseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "日本語の説明文が入ります。日本語の説明文が入ります。日本語の説明文が入ります。日本語の説明文が入ります。日本語の説明文"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size16)
        label.numberOfLines = .zero
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
        label.font = .appFont(type: .notoSansJP(.regular), size: .size13)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "06/01/2022"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size13)
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
        stackView.fillSuperView(inset: UIEdgeInsets(top: 9, left: 20, bottom: 9, right: 13))
        
        imageViewContainerView.addSubview(thumbnailImageView)
        thumbnailImageView.fillSuperView()
        
        thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.44).isActive = true
        
        imageViewContainerView.addSubview(tagsView)
        NSLayoutConstraint.activate([
            tagsView.leadingAnchor.constraint(equalTo: imageViewContainerView.leadingAnchor, constant: 6),
            tagsView.centerXAnchor.constraint(equalTo: imageViewContainerView.centerXAnchor),
            tagsView.topAnchor.constraint(equalTo: imageViewContainerView.topAnchor, constant: 6)
        ])
        
        tagsView.addSubview(firstIndicatorLabel)
        NSLayoutConstraint.activate([
            firstIndicatorLabel.leadingAnchor.constraint(equalTo: tagsView.leadingAnchor),
            firstIndicatorLabel.topAnchor.constraint(equalTo: tagsView.topAnchor),
            firstIndicatorLabel.bottomAnchor.constraint(equalTo: tagsView.bottomAnchor)
        ])
        
        tagsView.addSubview(secondIndicatorLabel)
        NSLayoutConstraint.activate([
            secondIndicatorLabel.leadingAnchor.constraint(equalTo: firstIndicatorLabel.trailingAnchor, constant: 8),
            secondIndicatorLabel.trailingAnchor.constraint(lessThanOrEqualTo: tagsView.trailingAnchor),
            secondIndicatorLabel.topAnchor.constraint(equalTo: tagsView.topAnchor),
            secondIndicatorLabel.bottomAnchor.constraint(equalTo: tagsView.bottomAnchor)
        ])
        
//        imageViewContainerView.addSubview(tagsStackView)
//        NSLayoutConstraint.activate([
//            tagsStackView.leadingAnchor.constraint(equalTo: imageViewContainerView.leadingAnchor, constant: 6),
//            tagsStackView.topAnchor.constraint(equalTo: imageViewContainerView.topAnchor, constant: 6)
//        ])
        
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
            timeStackView.topAnchor.constraint(greaterThanOrEqualTo: titleStackView.bottomAnchor, constant: 8),
            timeStackView.bottomAnchor.constraint(equalTo: detailContainerView.bottomAnchor)
        ])
        
        detailContainerView.bottomAnchor.constraint(greaterThanOrEqualTo: imageViewContainerView.bottomAnchor).isActive = true
    }
    
    private func setData() {
        thumbnailImageView.showImage(with: viewModel?.image)
        titleLabel.text = viewModel?.title
        japaneseTitleLabel.text = viewModel?.titleJapanese
        japaneseTitleLabel.isHidden = viewModel?.titleJapanese?.isEmpty ?? true
        timeLabel.text = viewModel?.duration
        timeLabel.isHidden = viewModel?.duration?.isEmpty ?? true
        dateLabel.text = viewModel?.releaseDate
        dateLabel.isHidden = viewModel?.releaseDate?.isEmpty ?? true
        setTags()
    }
    
    private func setTags() {
//        tagsStackView.arrangedSubviews.forEach({tagsStackView.removeArrangedSubview($0)})
//        viewModel?.tags?.forEach({
//            let label = PaddingLabel(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
//            label.translatesAutoresizingMaskIntoConstraints = false
//            label.heightAnchor.constraint(equalToConstant: 22).isActive = true
//            label.backgroundColor = UIColor.appGreen
//            label.font = .appFont(type: .notoSansJP(.regular), size: .size11)
//            label.curve = 2
//            label.text = $0
//            label.textColor = .white
//            tagsStackView.addArrangedSubview(label)
//        })
        [firstIndicatorLabel, secondIndicatorLabel].forEach({$0.isHidden = true})
        viewModel?.tags?.enumerated().forEach({
            if $0.offset == .zero {
                firstIndicatorLabel.text = $0.element
                firstIndicatorLabel.isHidden = $0.element.isEmpty
            } else if $0.offset == 1 {
                secondIndicatorLabel.text = $0.element
                secondIndicatorLabel.isHidden = $0.element.isEmpty
            }
        })
    }
    
}
