//
//  InstrumentDetailButtonView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 23/06/2022.
//

import UIKit

class InstrumentDetailButtonView: UIView {
    
    //MARK: UI Properties
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#6A6A6A")
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buyButton,
                                                       premiumButton,
//                                                       premiumAppendixButton,
//                                                       buyMultipleButton,
                                                       infoLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private(set) lazy var buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size14)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.buyMinusOne.value, for: .normal)
        button.backgroundColor = .black
        button.curve = 8
        return button
    }()
    
    private(set) lazy var premiumButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size14)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.clickForPremiumVideo.value, for: .normal)
        button.backgroundColor = UIColor(hexString: "#B2964E")
        button.curve = 8
        return button
    }()
    
//    private(set) lazy var premiumAppendixButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
//        button.setTitleColor(.white, for: .normal)
//        button.setTitle("PREMIUM映像", for: .normal)
//        button.backgroundColor = UIColor(hexString: "#B2964E")
//        button.curve = 8
//        return button
//    }()
    
    private(set) lazy var buyMultipleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .notoSansJPRegular(size: .size14)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.buyOtherPart.value, for: .normal)
        button.backgroundColor = .black
        button.curve = 8
        return button
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.partVideoInfo.value
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
    }
    
}
