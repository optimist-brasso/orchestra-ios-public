//
//  InstrumentPlayerView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 30/06/2022.
//

import UIKit

class InstrumentPlayerView: UIView {
    
    //MARK: Properties
    var viewModel: InstrumentPlayerPopupViewModel? {
        didSet {
            let isBought = viewModel?.isPartBought ?? false
            buyStackView.isHidden = isBought
            purchasedView.isHidden = !isBought
            buyPremiumVideoButton.isHidden = viewModel?.isPremiumBought ?? false
        }
    }
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [purchasedView,
                                                       buyStackView,
                                                       buyPremiumVideoButton,
                                                       buyMultiplePartButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 13
        return stackView
    }()
    
    private lazy var purchasedView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 35).isActive = true
        view.curve = 10
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var checkmarkImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "checkboxSelected")?.withTintColor(UIColor(hexString: "#C99100")))
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 14).isActive = true
        img.heightAnchor.constraint(equalTo: img.widthAnchor).isActive = true
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var purchasedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.partPurchased.value
        label.font = .notoSansJPBold(size: .size16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var buyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buyButton,
                                                       addToCartButton])
        stackView.axis = .vertical
        stackView.spacing = 13
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private(set) lazy var buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.titleLabel?.font = .notoSansJPBold(size: .size16)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.buyThisPartStatement.value, for: .normal)
        button.backgroundColor = .black
        button.curve = 10
        return button
    }()
    
    private(set) lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .notoSansJPBold(size: .size16)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.addToCart.value, for: .normal)
        button.backgroundColor = .black
        button.curve = 10
        return button
    }()
    
    private(set) lazy var buyPremiumVideoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.titleLabel?.font = .notoSansJPBold(size: .size16)
        button.setTitleColor(.black, for: .normal)
        button.setTitle(LocalizedKey.buyPremiumVideo.value, for: .normal)
        button.set(borderWidth: 2, of: .black)
        button.curve = 10
        return button
    }()
    
    private(set) lazy var buyMultiplePartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.titleLabel?.font = .notoSansJPBold(size: .size16)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.buyOtherPart.value, for: .normal)
        button.backgroundColor = .black
        button.curve = 10
        return button
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
        
        purchasedView.addSubview(checkmarkImage)
        NSLayoutConstraint.activate([
            checkmarkImage.leadingAnchor.constraint(equalTo: purchasedView.leadingAnchor, constant: 20),
            checkmarkImage.centerYAnchor.constraint(equalTo: purchasedView.centerYAnchor)
        ])
        
        purchasedView.addSubview(purchasedLabel)
        NSLayoutConstraint.activate([
            purchasedLabel.centerXAnchor.constraint(equalTo: purchasedView.centerXAnchor),
            purchasedLabel.centerYAnchor.constraint(equalTo: purchasedView.centerYAnchor),
        ])
    }
    
}
