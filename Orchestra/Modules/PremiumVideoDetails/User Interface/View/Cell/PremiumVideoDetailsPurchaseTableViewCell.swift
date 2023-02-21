//
//  PremiumVideoDetailsPurchaseTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//

import UIKit

class PremiumVideoDetailsPurchaseTableViewCell: UITableViewCell {
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       descriptionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "特典映像の詳細説明がはいります。特典映像の詳細説明がはいります。"
        label.font = .appFont(type: .notoSansJP(.light), size: .size14)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.curve = 12
        view.backgroundColor = UIColor(hexString: "#F1F1F1")
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "特典映像の詳細説明がはいります。特典映像の詳細説明がはいります。"
        label.font = .appFont(type: .notoSansJP(.medium), size: .size14)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()

    //MARK: Intializers
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
        stackView.fillSuperView(inset: UIEdgeInsets(top: 37, left: 35, bottom: 37, right: 35))
        
        descriptionView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 16),
            descriptionLabel.centerXAnchor.constraint(equalTo: descriptionView.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 60),
            descriptionLabel.centerYAnchor.constraint(equalTo: descriptionView.centerYAnchor),
        ])
    }
    
}
