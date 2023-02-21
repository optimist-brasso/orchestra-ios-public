//
//  RegisterScreen.swift
//  Orchestra
//
//  Created by manjil on 30/03/2022.
//

import UIKit
import FirebaseAuth

class RegisterScreen: CancelScreen {
    
    private lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = LocalizedKey.registerAnAccount.value
        label.textColor = .blueButtonBackground
        label.font =  .notoSansJPBold(size: .size16)
        return label
    }()
    
    private lazy var registerByEmailOrSNS: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text =  LocalizedKey.registerByEmailSNS.value //"Register by email/sns"
        label.font =  .notoSansJPRegular(size: .size16)
        return label
    }()
    
    private(set) lazy var registerByEmailButton: AppButton = {
        let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.appButtonType = .border
        button.setAttributedTitle(LocalizedKey.registerByEmail.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16)]), for: .normal)
        return button
    }()
    
    private lazy var registerBySNS: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = LocalizedKey.useAnSNSAccount.value
        label.font =  .notoSansJPRegular(size: .size16)
        return label
    }()
    
    private(set) lazy var registerByLineButton: ImageButton = {
        let button = ImageButton(image: .line, title: LocalizedKey.continueWithLine.value)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.textColor = .line
//        let button = AppButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitleColor(.border, for: .normal)
//        button.layer.borderColor = UIColor.border.cgColor
//        button.setImage(.line, for: .normal)
//        button.configuration = UIButton.Configuration.plain()
//        button.configuration?.titleAlignment = .center
//        button.configuration?.imagePadding = 20
//        button.appButtonType = .border
//        button.setAttributedTitle(LocalizedKey.continueWithLine.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size14), .foregroundColor: UIColor.line]), for: .normal)
        return button
    }()
    private(set) lazy var registerByTwitterButton: ImageButton = {
        let button = ImageButton(image: .twitter, title: LocalizedKey.continueOnTwitter.value)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.textColor = .twitter
//        let button = AppButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.borderColor = UIColor.border.cgColor
//        button.setImage(.twitter, for: .normal)
//        button.setTitleColor(.border, for: .normal)
//        button.configuration = UIButton.Configuration.plain()
//        button.configuration?.titleAlignment = .center
//        button.configuration?.imagePadding = 20
//        button.appButtonType = .border
//        button.setAttributedTitle(LocalizedKey.continueOnTwitter.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size14), .foregroundColor: UIColor.twitter]), for: .normal)
        return button
    }()
    
    private(set) lazy var registerByFacebookButton: ImageButton = {
        let button = ImageButton(image: .facebook, title: LocalizedKey.continueOnFacebook.value)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.textColor = .facebook
//        button.setImage(.facebook, for: .normal)
//        button.setTitleColor(.border, for: .normal)
//        button.configuration = UIButton.Configuration.plain()
//        button.configuration?.titleAlignment = .center
//        button.configuration?.imagePadding = 20
//        button.setAttributedTitle(LocalizedKey.continueOnFacebook.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size14), .foregroundColor: UIColor.facebook]), for: .normal)
//        button.appButtonType = .border
        return button
    }()
    
    private(set) lazy var registerByAppleButton: ImageButton = {
        let button = ImageButton(image: UIImage(named: "apple")!, title: LocalizedKey.continueOnApple.value)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.textColor = .black
//        let button = AppButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.borderColor = UIColor.border.cgColor
//        button.setImage(UIImage(systemName: "applelogo"), for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.configuration = UIButton.Configuration.plain()
//        button.configuration?.titleAlignment = .center
//        button.configuration?.imagePadding = 20
//        button.appButtonType = .border
//        button.tintColor = .black
//        button.setAttributedTitle(LocalizedKey.continueOnApple.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size14), .foregroundColor: UIColor.black]), for: .normal)
        return button
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private(set) lazy var termView: UIStackView = {
        let view = UIView()
        view.addSubview(tickButton)
        tickButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tickButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tickButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        let scroll = UIStackView(arrangedSubviews: [view, termButton])
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.spacing = 8
        scroll.axis = .horizontal
        scroll.distribution = .fill
        return scroll
    }()
    
    private(set) lazy var tickButton: CheckButton = {
        let button = CheckButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .blueButtonBackground
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return button
    }()
    
    private(set) lazy var termButton: UITextView = {
        let button = UITextView()
        button.translatesAutoresizingMaskIntoConstraints = false
        let string = """
                     利用規約:利用規約に同意する
                     """
        let stringRange = NSRange(location: 0, length: string.count)
        let range1 = (string as NSString).range(of: "利用規約")
        let attributeString = NSMutableAttributedString(string: string)
        attributeString.addAttribute(.link, value: "terms", range: range1)
        button.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blueButtonBackground, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        button.attributedText = attributeString
        button.font = UIFont.notoSansJPRegular(size: .size14)
        button.isUserInteractionEnabled = true
        button.textAlignment = .center
        button.isEditable = false
        button.isScrollEnabled = false
       
        return button
    }()
    
    private(set) lazy var loginButton: AppButton = {
        let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.setAttributedTitle(LocalizedKey.loginNow.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16)]), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.appButtonType = .border
        return button
    }()
    
    override func create() {
        addSubview(scroll)
        scroll.addSubview(title)
        scroll.addSubview(registerByEmailOrSNS)
        scroll.addSubview(registerByEmailButton)
        scroll.addSubview(stack)
        stack.addArrangedSubview(registerBySNS)
        stack.addArrangedSubview(registerByLineButton)
        stack.addArrangedSubview(registerByTwitterButton)
        stack.addArrangedSubview(registerByFacebookButton)
        stack.addArrangedSubview(registerByAppleButton)
        scroll.addSubview(termView)
        scroll.addSubview(loginButton)
        // addSubview(cancelButton)
        
        super.create()
        
        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: cancelButton.topAnchor),
            scroll.widthAnchor.constraint(equalTo: widthAnchor),
            
            title.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            title.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 16),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            registerByEmailOrSNS.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 64),
            registerByEmailOrSNS.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 32),
            registerByEmailOrSNS.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            registerByEmailButton.leadingAnchor.constraint(equalTo: registerByEmailOrSNS.leadingAnchor),
            registerByEmailButton.topAnchor.constraint(equalTo: registerByEmailOrSNS.bottomAnchor, constant: 22),
            registerByEmailButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            registerByEmailButton.heightAnchor.constraint(equalToConstant: 50),
            
            stack.leadingAnchor.constraint(equalTo: registerByEmailOrSNS.leadingAnchor),
            stack.topAnchor.constraint(equalTo: registerByEmailButton.bottomAnchor, constant: 52),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            registerBySNS.heightAnchor.constraint(equalToConstant: 50),
            
            termView.leadingAnchor.constraint(greaterThanOrEqualTo: stack.leadingAnchor),
            termView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 25),
            termView.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
//            termView.trailingAnchor.constraint(lessThanOrEqualTo: scroll.trailingAnchor),
            
            loginButton.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 64),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: termView.bottomAnchor, constant: 25),
            loginButton.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -38),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
