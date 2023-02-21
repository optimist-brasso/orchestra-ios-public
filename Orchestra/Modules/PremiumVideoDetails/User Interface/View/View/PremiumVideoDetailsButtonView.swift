//
//  PremiumVideoDetailsButtonView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//

import UIKit

class PremiumVideoDetailsButtonView: UIView {
    
    //MARK: Properties
    var purchased = false {
        didSet {
//            [topStackView].forEach({
////             seperateUnpurchaseableLabel].forEach({
//                $0.isHidden = purchased
//            })
//            if purchased {
//                stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//                backButton.topAnchor.constraint(equalTo: backView.topAnchor, constant: 15).isActive = true
//            }
        }
    }
    
    //MARK: UI Properties
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#6A6A6A")
        return view
    }()
    
    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buyButton,
                                                       premiumAppendixButton,
                                                       infoLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 9
        return stackView
    }()
    
//    private lazy var topStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [buyButton,
//                                                       premiumAppendixButton,
//                                                       infoLabel])
//        stackView.axis = .vertical
//        stackView.spacing = 9
//        return stackView
//    }()
    
//    private(set) lazy var addToCartButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
//        button.setTitleColor(.white, for: .normal)
//        button.setTitle(LocalizedKey.addToCart.value, for: .normal)
//        button.backgroundColor = UIColor(hexString: "#B2964E")
//        button.curve = 8
//        return button
//    }()
    
    private(set) lazy var premiumAppendixButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size14)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.clickForBonusVideo.value, for: .normal)
        button.backgroundColor = UIColor(hexString: "#B2964E")
        button.curve = 8
        return button
    }()
    
    private(set) lazy var buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size14)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.buyPremiumVideoBundle.value, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = UIColor(hexString: "#B2964E")
        button.curve = 8
        return button
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var seperateUnpurchaseableLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.premiumVideoSeperateUnpurchasable.value
        label.font = .appFont(type: .notoSansJP(.bold), size: .size14)
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.returnToPartVideo.value, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = .black
        button.curve = 8
        return button
    }()
    
    private(set) lazy var bulkBuyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
//        button.setTitleColor(.white, for: .normal)
        button.setTitle("複数セットをまとめて購入", for: .normal)
        button.backgroundColor = .black
        button.curve = 8
        return button
    }()
    
    private(set) lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.premiumVideoInfo.value
        label.numberOfLines = .zero
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
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
        addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 30, left: 32, bottom: 30, right: 32))
        
        backView.addSubview(seperateUnpurchaseableLabel)
        NSLayoutConstraint.activate([
            seperateUnpurchaseableLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            seperateUnpurchaseableLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            seperateUnpurchaseableLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 6),
        ])
        
//        backView.addSubview(backButton)
//        NSLayoutConstraint.activate([
//            backButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
//            backButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
//            backButton.topAnchor.constraint(equalTo: seperateUnpurchaseableLabel.bottomAnchor, constant: 10),
//            backButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
//        ])
    }
    
}

