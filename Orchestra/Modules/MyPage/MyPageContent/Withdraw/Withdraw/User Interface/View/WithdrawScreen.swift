//
//  WithdrawScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//
//

import UIKit

class WithdrawScreen: BaseScreen {
    
    // MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleView,
                                                       scrollView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#C4C4C4").withAlphaComponent(0.4)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.withdrawl.value
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [withdrawStackView,
                                                       cancelButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 38
        return stackView
    }()
    
    private lazy var withdrawStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [warningConfirmationLabel,
                                                       withdrawButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var warningConfirmationLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.withdrawConfirmation.value
        label.font = .appFont(type: .notoSansJP(.regular), size: .size18)
        return label
    }()
    
    private(set) lazy var withdrawButton: AppButton = {
        let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizedKey.withdraw.value, for: .normal)
        button.titleLabel?.font = .notoSansJPMedium(size: .size16)
        button.setTitleColor(.black, for: .normal)
        button.appButtonType = .border
        return button
    }()
    
    private(set) lazy var cancelButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSAttributedString(string: LocalizedKey.cancel.value, attributes: [.foregroundColor : UIColor.black,
                                                                                                 .font: UIFont.notoSansJPRegular(size: .size15),
                                                                                                 .underlineStyle: NSUnderlineStyle.single.rawValue])
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        addSubview(stackView)
        stackView.fillSuperView()
        
        scrollView.addSubview(containerView)
        containerView.fillSuperView()
        
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        titleView.addSubview(titleLabel)
        titleLabel.fillSuperView(inset: UIEdgeInsets(top: 12, left: 25, bottom: 12, right: 25))
        
        containerView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            contentStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
