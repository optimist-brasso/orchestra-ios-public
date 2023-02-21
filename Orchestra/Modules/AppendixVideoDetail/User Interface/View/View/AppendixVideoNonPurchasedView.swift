//
//  AppendixVideoNonPurchasedView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//

import UIKit

class AppendixVideoNonPurchasedView: UIView {
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       descriptionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""// "特典映像の詳細説明がはいります。特典映像の詳細説明がはいります。"
        label.font = .appFont(type: .notoSansJP(.light), size: .size14)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        view.backgroundColor = UIColor(hexString: "#F1F1F1")
        view.curve = 12
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PREMIUM映像購入後に表示されます"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
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
        addSubview(stackView)
        stackView.fillSuperView()
        
        descriptionView.addSubview(descriptionLabel)
        descriptionLabel.fillSuperView(inset: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
}
