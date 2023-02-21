//
//  ResetPasswordScreen.swift
//  Orchestra
//
//  Created by manjil on 18/04/2022.
//

import UIKit

class ResetPasswordScreen: CancelScreen {
    
    
    private(set) lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .blueButtonBackground
        label.text = LocalizedKey.forgotPasswordTitle.value
        label.font =  .notoSansJPBold(size: .size16)
        return label
    }()
    
    private lazy var  stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 16
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private(set) lazy var token: ChangePasswordText = {
        let view = ChangePasswordText()
        view.textfield.rightImage = nil
        view.textfield.isSecureTextEntry = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text = LocalizedKey.oneTimePassword.value
        view.textfield.attributedPlaceholder = LocalizedKey.pleaseEnterYourOTP.value.placeholder
        return view
    }()
    
    private(set) lazy var newPassword: ChangePasswordText = {
        let view = ChangePasswordText()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text =  LocalizedKey.newPassword.value
        return view
    }()
    
    private(set) lazy var changeButton: AppButton = {
       let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(LocalizedKey.completeTheInput.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size14)]), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.appButtonType = .auth
        
        return button
    }()
    
    
    override func create() {

        addSubview(title)
        addSubview(stack)
        
        stack.addArrangedSubview(token)
        stack.addArrangedSubview(newPassword)
        stack.setCustomSpacing(35, after: newPassword)
        stack.addArrangedSubview(changeButton)
        super.create()
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            stack.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 35),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            newPassword.widthAnchor.constraint(equalTo: stack.widthAnchor),
            token.widthAnchor.constraint(equalTo: stack.widthAnchor),
            
            changeButton.heightAnchor.constraint(equalToConstant: 44),
            changeButton.widthAnchor.constraint(equalToConstant: 195),
            
        ])
    }
}


