//
//  InstrumentDetailBuyScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import UIKit

enum InstrumentDetailBuyState {
    
    case initial,
         purchased,
         addedToCart
    
    var confirmationMessage: String {
        switch self {
        case .initial:
            return LocalizedKey.wouldYouBuy.value
        case .purchased:
            return LocalizedKey.bought.value
        case .addedToCart:
            return LocalizedKey.addedToCart.value
        }
    }
    
}

class InstrumentDetailBuyScreen: BaseScreen {
    
    //MARK: Properties
    var state: InstrumentDetailBuyState = .initial {
        didSet {
            confirmationMessageLabel.text = state.confirmationMessage
            buttonStackView.isHidden = state != .initial
            priceLabel.isHidden = state != .initial
            cartButton.isHidden = state != .addedToCart
        }
    }
    var viewModel: InstrumentDetailBuyViewModel? {
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
    
//    private lazy var stackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [topStackView,
//                                                       confirmationMessageLabel])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.spacing = 45
//        return stackView
//    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "English Title"
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size18)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "日本語表記の楽曲名"
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size18)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "日本語表記の楽曲名"
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size18)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var confirmationMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = state.confirmationMessage
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size14)
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
        stackView.spacing = 30
        return stackView
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buyButton,
                                                       addToCartButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private(set) lazy var buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 37).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size16)
        button.setTitleColor(UIColor(hexString: "#6A6969"), for: .normal)
        button.setTitle(LocalizedKey.buy.value, for: .normal)
        button.backgroundColor = .white
        button.curve = 6
        return button
    }()
    
    private(set) lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .notoSansJPRegular(size: .size16)
        button.setTitleColor(UIColor(hexString: "#6A6969"), for: .normal)
        button.setTitle(LocalizedKey.addToCart.value, for: .normal)
        button.backgroundColor = .white
        button.curve = 6
        return button
    }()
    
    private(set) lazy var cartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 170).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size16)
        button.setTitleColor(UIColor(hexString: "#6A6969"), for: .normal)
        button.setTitle(LocalizedKey.moveToCart.value, for: .normal)
        button.backgroundColor = .white
        button.curve = 6
        button.isHidden = true
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
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
//            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        containerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 17),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 17)
        ])
        
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 14)
        ])
        
        containerView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 64)
        ])
        
        containerView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4)
        ])
        
        containerView.addSubview(confirmationMessageLabel)
        NSLayoutConstraint.activate([
            confirmationMessageLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            confirmationMessageLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            confirmationMessageLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 24)
        ])
        
        containerView.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 67),
            buttonStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: confirmationMessageLabel.bottomAnchor, constant: 52),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -47)
        ])
        
        containerView.addSubview(cartButton)
        NSLayoutConstraint.activate([
            cartButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            cartButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -39)
        ])
    }
    
    private func setData() {
        titleLabel.text = viewModel?.title
        descriptionLabel.text = viewModel?.type
        priceLabel.text = viewModel?.price
        if let type = viewModel?.sessionType {
            if type == .combo {
                confirmationMessageLabel.text = LocalizedKey.wouldYouBuyAsSet.value
            }
            cartButton.setTitle((type == .premium ? LocalizedKey.moveToCart : LocalizedKey.moveToCartShort).value, for: .normal)
        }
//        buyButton.setTitle(LocalizedKey.rec.value, for: .normal)
    }
    
}
