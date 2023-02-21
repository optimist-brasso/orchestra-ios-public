//
//  MyPageHeaderTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var title: String? {
        didSet {
            label.text = title
        }
    }
    
    var detail: String? {
        didSet {
            descriptionLabel.text = detail
            descriptionLabel.isHidden = detail?.isEmpty ?? true
        }
    }
    var allowNavigation = true {
        didSet {
            arrowImageView.isHidden = !allowNavigation
        }
    }
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label,
                                                       descriptionLabel,
                                                       arrowImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        label.isHidden = true
        label.textAlignment = .right
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: GlobalConstants.Image.rightArrow)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#D0D0D0").withAlphaComponent(0.6)
        return view
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
        stackView.fillSuperView(inset: UIEdgeInsets(top: 21, left: 27, bottom: 22, right: 32))
        
        contentView.addSubview(seperatorView)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            seperatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
