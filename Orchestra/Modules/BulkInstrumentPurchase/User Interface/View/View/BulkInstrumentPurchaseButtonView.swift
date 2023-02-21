//
//  BulkInstrumentPurchaseButtonView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 21/06/2022.
//

import UIKit

class BulkInstrumentPurchaseButtonView: UIView {
    
    //MARK: UI Properties
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bulkBuyButton,
                                                       addToCartButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private(set) lazy var bulkBuyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
//        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.buy.value, for: .normal)
        button.backgroundColor = .black
        button.curve = 8
        return button
    }()
    
    private(set) lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.addAllInCart.value, for: .normal)
        button.backgroundColor = .black
        button.curve = 8
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
        addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 21, left: 32, bottom: 20, right: 32))
    }
    
}
