//
//  ChangePasswordScreen.swift
//  Orchestra
//
//  Created by manjil on 15/04/2022.
//

import UIKit

class ChangePasswordText: UIStackView {
    private(set) lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .notoSansJPMedium(size: .size16)
        return label
    }()
     
    private(set) lazy var textfield: PasswordTextField = {
        let textfield = PasswordTextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = .notoSansJPRegular(size: .size16)
        textfield.attributedPlaceholder = LocalizedKey.pleaseEnterPassword.value.placeholder
        textfield.textColor = .black
        return textfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createDesign()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        createDesign()
    }
    
    private func createDesign() {
        axis = .vertical
        spacing = 11
        distribution = .fill
        
        addArrangedSubview(title)
        addArrangedSubview(textfield)
        
        textfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
}

class ChangePasswordScreen: BaseScreen {
    
    private lazy var  scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
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
        label.text = LocalizedKey.changePassword.value
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    private(set) lazy var oldPassword: ChangePasswordText = {
        let view = ChangePasswordText()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text = LocalizedKey.oldPassword.value
        return view
    }()
    
    private(set) lazy var forgotButton: AppButton = {
       let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(LocalizedKey.ifYouDontKnowPassword.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size12)]), for: .normal)
        button.setTitleColor(.border, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.isHidden = true 
        return button
    }()
    
    private(set) lazy var newPassword: ChangePasswordText = {
        let view = ChangePasswordText()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text =  LocalizedKey.newPassword.value
        return view
    }()
    
    private(set) lazy var confirmPassword: ChangePasswordText = {
        let view = ChangePasswordText()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text = LocalizedKey.newPasswordConfirm.value
        return view
    }()
    
    private(set) lazy var changeButton: AppButton = {
       let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(LocalizedKey.change.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size14)]), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.appButtonType = .border
        return button
    }()
    
    
    private(set) lazy var cancelButton: AppButton = {
       let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(LocalizedKey.cancel.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size14)]), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.configuration = UIButton.Configuration.plain()
        button.configuration?.titleAlignment = .leading
        button.configuration?.imagePadding = 50
        button.configuration?.imagePlacement = .trailing
        button.layer.cornerRadius = 0
        button.setImage(.cross.setTemplate(), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    
    override func create() {
        super.create()
        addSubview(scroll)
        scroll.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleLabel.fillSuperView(inset: UIEdgeInsets(top: 12, left: 26, bottom: 12, right: 26))
        scroll.addSubview(oldPassword)
        scroll.addSubview(forgotButton)
        scroll.addSubview(newPassword)
        scroll.addSubview(confirmPassword)
        scroll.addSubview(changeButton)
        scroll.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.centerXAnchor.constraint(equalTo: centerXAnchor),
            scroll.centerYAnchor.constraint(equalTo: centerYAnchor),
            scroll.widthAnchor.constraint(equalTo: widthAnchor),
            
            titleView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            titleView.topAnchor.constraint(equalTo: scroll.topAnchor),
            titleView.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
            oldPassword.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 27),
            oldPassword.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 54),
            oldPassword.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
            forgotButton.leadingAnchor.constraint(equalTo: oldPassword.leadingAnchor),
            forgotButton.topAnchor.constraint(equalTo: oldPassword.bottomAnchor, constant: 8),
            forgotButton.heightAnchor.constraint(equalToConstant: 18),
            
            newPassword.leadingAnchor.constraint(equalTo: oldPassword.leadingAnchor),
            newPassword.topAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: 36),
            newPassword.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
            confirmPassword.leadingAnchor.constraint(equalTo: oldPassword.leadingAnchor),
            confirmPassword.topAnchor.constraint(equalTo: newPassword.bottomAnchor, constant: 16),
            confirmPassword.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
            changeButton.topAnchor.constraint(equalTo: confirmPassword.bottomAnchor, constant: 43),
            changeButton.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            changeButton.heightAnchor.constraint(equalToConstant: 44),
            changeButton.widthAnchor.constraint(equalToConstant: 195),
            
            cancelButton.topAnchor.constraint(equalTo: changeButton.bottomAnchor, constant: 38),
            cancelButton.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            //cancelButton.widthAnchor.constraint(equalToConstant: 150),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -38)
            
        ])
    }
}


