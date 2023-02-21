//
//  HomeHeaderTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//

import UIKit

class HomeHeaderTableViewCell: UITableViewCell {
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recommendedStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var recommendedStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recommendedImageView, recommendedLabel])
        stackView.spacing = 7
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var recommendedImageView: UIImageView = {
        let imageView = UIImageView(image: GlobalConstants.Image.play)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var recommendedLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.recommendedContent.value
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    private lazy var seeMoreStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [seeMoreLabel, arrowImageView])
        stackView.spacing = 7
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var seeMoreLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.seeMore.value
        label.font = .appFont(type: .notoSansJP(.regular), size: .size11)
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: GlobalConstants.Image.borderedRightArrow)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: Initilializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .white
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        contentView.addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }
    
}
