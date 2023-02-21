//
//  InstrumentPlayerPopupPremiumView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 30/06/2022.
//

import UIKit

class InstrumentPlayerPremiumPopupView: UIView {
    
    struct Constants {
        static let buttonColor = UIColor(hexString: "#B2964E")
        static let buttonCurve: CGFloat = 8
    }
    
    //MARK: Properties
    var viewModel: InstrumentPlayerPopupViewModel? {
        didSet {
            let isPartBought = viewModel?.isPartBought ?? false
            buyButton.setTitle((isPartBought ? LocalizedKey.buy : LocalizedKey.buyPremiumVideoBundle).value, for: .normal)
            seperateUnpurchaseableLabel.isHidden = isPartBought
            let isPremiumBought = viewModel?.isPremiumBought ?? false
            buyStackView.isHidden = isPremiumBought
        }
    }
    var isAppendixVideo = false {
        didSet {
            checkAppendixVideoButton.isHidden = isAppendixVideo
        }
    }
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buyStackView,
                                                       checkAppendixVideoButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var buyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buyButton,
                                                       addToCartButton,
                                                       seperateUnpurchaseableLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private(set) lazy var buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.titleLabel?.font = .notoSansJPBold(size: .size16)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.buyPremiumVideoBundle.value, for: .normal)
        button.backgroundColor = Constants.buttonColor
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.curve = Constants.buttonCurve
        return button
    }()
    
    private(set) lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.titleLabel?.font = .notoSansJPBold(size: .size16)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.addToCart.value, for: .normal)
        button.backgroundColor = Constants.buttonColor
        button.curve = Constants.buttonCurve
        return button
    }()
    
    private lazy var seperateUnpurchaseableLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.premiumVideoSeperateUnpurchasable.value
        label.font = .appFont(type: .notoSansJP(.bold), size: .size15)
        label.textAlignment = .center
        return label
    }()
        
    private(set) lazy var checkAppendixVideoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.titleLabel?.font = .notoSansJPBold(size: .size16)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.checkAppendixPremiumVideo.value, for: .normal)
        button.backgroundColor = .black
        button.curve = Constants.buttonCurve
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
    }
    
}
