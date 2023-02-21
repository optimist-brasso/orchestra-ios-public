//
//  BuyScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/04/2022.
//
//

import UIKit
import SwiftUI

class BuyScreen: BaseScreen {
    
    //MARK: Properties
    var viewModel: BuyViewModel? {
        didSet {
            setData()
        }
    }
    
    // MARK: UI Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.isUserInteractionEnabled = true
        view.curve = 10
        return view
    }()
    
    private(set) lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 18).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(UIImage(named: "cross"), for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView,
                                                       confirmationMessageLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 45
        return stackView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView,
                                                       descriptionStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       japaneseTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size16)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var japaneseTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size20)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [venueLabel,
                                                      priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var venueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size14)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size18)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var confirmationMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "を購入しますか？"
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size18)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [actionStackView,
                                                       cancelButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buyButton,
                                                       addToCartButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 9
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private(set) lazy var buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 37).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
        button.setTitleColor(UIColor(hexString: "#6A6969"), for: .normal)
        button.setTitle(LocalizedKey.buy.value, for: .normal)
        button.backgroundColor = .white
        button.curve = 6
        return button
    }()
    
    private(set) lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
        button.setTitleColor(UIColor(hexString: "#6A6969"), for: .normal)
        button.setTitle(LocalizedKey.addToCart.value, for: .normal)
        button.backgroundColor = .white
        button.curve = 6
        return button
    }()
    
    private(set) lazy var cancelButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSAttributedString(string: LocalizedKey.cancel.value, attributes: [.foregroundColor : UIColor.white,
                                                                               NSAttributedString.Key.font: UIFont.notoSansJPRegular(size: .size15),
                                                                                                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        backgroundColor = .clear
        
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        containerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16)
        ])
        
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 48)
        ])
        
        containerView.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 67),
            buttonStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 86),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -50)
        ])
        actionStackView.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor).isActive = true
    }
    
    private func setData() {
        titleLabel.text = viewModel?.title
        japaneseTitleLabel.text = viewModel?.titleJapanese
        venueLabel.text = viewModel?.venue
        venueLabel.isHidden = viewModel?.venue?.isEmpty ?? true
        priceLabel.text = viewModel?.price
    }
    
}
