//
//  WithdrawConfirmationScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//
//

import UIKit

enum WithdrawState {
    
    case initial,
         withdrawn
    
    var confirmationMessage: String {
        switch self {
        case .initial:
            return LocalizedKey.stillWithdraw.value
        case .withdrawn:
            return LocalizedKey.withdrawn.value
        }
    }
    
}

class WithdrawConfirmationScreen: BaseScreen {
    
    //MARK: Properties
    var state: WithdrawState = .initial {
        didSet {
            confirmationMessageLabel.text = state.confirmationMessage
            buttonStackView.isHidden = state != .initial
            titleLabel.isHidden = state != .initial
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
        label.text = "退会されると\n購入・編集済みコンテンツの\n復元ができなくります"
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
        label.font = .notoSansJPRegular(size: .size18)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [yesButton,
                                                       cancelButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 82
        return stackView
    }()
    
    private(set) lazy var yesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        button.widthAnchor.constraint(equalToConstant: 170).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size16)
        button.setTitle(LocalizedKey.yes.value, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.curve = 5
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
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 74)
        ])
        
        containerView.addSubview(confirmationMessageLabel)
        NSLayoutConstraint.activate([
            confirmationMessageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            confirmationMessageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            confirmationMessageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24)
        ])
        
        containerView.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 67),
            buttonStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: confirmationMessageLabel.bottomAnchor, constant: 74),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -47)
        ])
    }
    
}
