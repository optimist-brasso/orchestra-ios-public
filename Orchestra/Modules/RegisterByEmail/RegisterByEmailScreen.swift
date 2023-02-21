//
//  RegisterByEmailScreen.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import UIKit

class CancelScreen: BaseScreen {
    
    private(set) lazy var cancelButton: AppButton = {
        let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .buttonBackground
        button.configuration = UIButton.Configuration.plain()
        button.configuration?.titleAlignment = .center
        button.configuration?.imagePadding = 20
        button.configuration?.imagePlacement = .trailing
        button.layer.cornerRadius = 0
        button.setImage(.cross, for: .normal)
        button.tintColor = .white
        button.setAttributedTitle(LocalizedKey.cancel.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size16), .foregroundColor: UIColor.white]), for: .normal)
        return button
    }()
    
    override func create() {
        super.create()
        addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 82),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

class RegisterByEmailScreen: CancelScreen {
    
    private(set) lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .blueButtonBackground
        label.text = LocalizedKey.registerAnAccount.value
        label.font =  .notoSansJPBold(size: .size16)
        return label
    }()
    
    private(set) lazy var subTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text =  LocalizedKey.emailAddress.value
        label.font =  .notoSansJPRegular(size: .size16)
        return label
    }()
    
    private(set) lazy var email: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text =  LocalizedKey.emailAddress.value
        label.font =   .notoSansJPRegular(size: .size14)
        label.isHidden = true
        return label
    }()
    
    private(set) lazy var textfield: PasswordTextField = {
        let textfield = PasswordTextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.textAlignment = .left
        textfield.attributedPlaceholder =  LocalizedKey.pleaseEnterYourEmailAddress.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16), .foregroundColor: UIColor.placeholder])
        textfield.isSecureTextEntry = false
        textfield.font = .notoSansJPMedium(size: .size16)
        return textfield
    }()
    
    private(set) lazy var reButton: AppButton = {
        let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle("Already got code".attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size16)]), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.isHidden = true
        return button
    }()
    
    private(set) lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.passwordNote.value
        label.numberOfLines = .zero
        label.font = .notoSansJPRegular(size: .size16)
        label.isHidden = true
        return label
    }()
    
    private(set) lazy var completionButton: AppButton = {
        let button = AppButton()
        button.appButtonType = .auth
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(LocalizedKey.toRegister.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16)]), for: .normal)
        return button
    }()
    
    override func create() {
        
        addSubview(title)
        addSubview(subTitle)
        addSubview(email)
        addSubview(textfield)
        addSubview(reButton)
        addSubview(infoLabel)
        addSubview(completionButton)
        super.create()
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            subTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 88),
            subTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            email.leadingAnchor.constraint(equalTo: subTitle.leadingAnchor),
            email.bottomAnchor.constraint(equalTo: textfield.topAnchor, constant: -16),
            email.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            textfield.leadingAnchor.constraint(equalTo: subTitle.leadingAnchor),
            textfield.topAnchor.constraint(equalTo: subTitle.bottomAnchor, constant: 64),
            textfield.centerXAnchor.constraint(equalTo: centerXAnchor),
            textfield.heightAnchor.constraint(equalToConstant: 45),
            
            reButton.topAnchor.constraint(equalTo: textfield.bottomAnchor, constant: 10),
            reButton.leadingAnchor.constraint(equalTo: textfield.leadingAnchor),
            reButton.heightAnchor.constraint(equalToConstant: 15),
            infoLabel.leadingAnchor.constraint(equalTo: reButton.leadingAnchor),
            infoLabel.topAnchor.constraint(equalTo: reButton.topAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: textfield.trailingAnchor),
           
            completionButton.topAnchor.constraint(equalTo: textfield.bottomAnchor, constant: 100),
            completionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            completionButton.heightAnchor.constraint(equalToConstant: 50),
            completionButton.widthAnchor.constraint(equalToConstant: 195),
            //completionButton.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            
        ])
    }
    
}
