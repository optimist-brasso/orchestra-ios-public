//
//  InstrumentBuySuccessView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 21/06/2022.
//

import UIKit

class InstrumentBuySuccessView: UIView {
    
    //MARK: Properties
    var isBuySuccess = true {
        didSet {
            confirmationMessageLabel.text = isBuySuccess ? LocalizedKey.purchasedInBulk.value : LocalizedKey.addedInCart.value
            nextButton.setTitle(isBuySuccess ? "戻る" : LocalizedKey.moveToCart.value, for: .normal) // 〇〇〇に戻る
        }
    }
    
    //MARK: UI Properties
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
        let stackView = UIStackView(arrangedSubviews: [titleStackView,
                                                       priceLabel,
                                                       confirmationMessageLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 60
        return stackView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       japaneseTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "English Title"
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size16)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var japaneseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "日本語表記の楽曲名"
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size20)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "９曲"
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size48)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var confirmationMessageLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.purchasedInBulk.value
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size18)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 75).isActive = true
        return view
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .white
        return view
    }()
    
    private(set) lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .notoSansJPLight(size: .size18)
        button.setTitleColor(.white, for: .normal)
//        button.setTitle("戻る", for: .normal)
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
        addSubview(containerView)
        containerView.fillSuperView()
        
        addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 17),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 17)
        ])
        
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 19),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 90)
        ])
        
        containerView.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            bottomView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 122),
            bottomView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        bottomView.addSubview(seperatorView)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            seperatorView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            seperatorView.topAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
        
        bottomView.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        ])
    }
    
}
