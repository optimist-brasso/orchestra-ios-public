//
//  CheckoutConfirmationScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/06/2022.
//
//

import UIKit

class CheckoutConfirmationScreen: BaseScreen {
    
    //MARK: Properties
    
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.purchase.value
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passwordTitleLabel,
                                                       textfield,
                                                       forgotPasswordLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.password.value
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size16)
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var textfield: PasswordTextField = {
        let textfield = PasswordTextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.heightAnchor.constraint(equalToConstant: 35).isActive = true
        textfield.font = .notoSansJPRegular(size: .size12)
        textfield.attributedPlaceholder = LocalizedKey.pleaseEnterPassword.value.placeholder
        textfield.layer.borderColor = UIColor.white.cgColor
        textfield.textAlignment = .center
        textfield.backgroundColor = .white
        return textfield
    }()
    
    private lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.forgetPassword.value
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size12)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buyButton,
                                                       cancelButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 22
        return stackView
    }()
    
    private(set) lazy var buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 37).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
        button.setTitleColor(UIColor(hexString: "#6A6969"), for: .normal)
        button.setTitle("購入する", for: .normal)
        button.backgroundColor = .white
        button.curve = 6
        return button
    }()
    
    private(set) lazy var cancelButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSAttributedString(string: LocalizedKey.cancel.value, attributes: [.foregroundColor : UIColor.white,
                                                                               NSAttributedString.Key.font: UIFont.notoSansJPRegular(size: .size14),
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
//            containerView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        containerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16)
        ])
        
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 18)
        ])
        
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 26),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 120)
        ])

        containerView.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 71),
            buttonStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 120),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -50)
        ])
        buyButton.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor).isActive = true
    }
    
}
