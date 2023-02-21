//
//  RegisterPasswordController.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import UIKit
import Combine

class RegisterPasswordController: BaseController {
    
    private var screen: RegisterByEmailScreen  {
        baseScreen as! RegisterByEmailScreen
    }
    
    private var presenter: RegisterPasswordPresenter  {
        basePresenter as! RegisterPasswordPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func observerScreen() {
        screen.completionButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            guard let self = self else { return }
            self.view.endEditing(true)
            self.validate()
        }.store(in: &presenter.bag)
        presenter.response.sink { [weak self] response in
            guard let self = self else { return }
            self.hideLoading()
            if response.1 {
                self.presenter.trigger.send(.updateProfile(self.screen.textfield.text))
                return
            }
            self.alert(title: "", msg: response.0, actions: [AlertConstant.ok])
        }.store(in: &presenter.bag)
    }
    
    override func setupUI() {
//        screen.reButton.isHidden = false
//        screen.reButton.isUserInteractionEnabled = false
        screen.subTitle.text = LocalizedKey.registerPassword.value
        screen.textfield.placeholder = LocalizedKey.pleaseEnterYourPassword.value
        screen.infoLabel.isHidden = false
        //screen.reButton.setTitle(LocalizedKey.passwordNote.value, for: .normal)
//        screen.reButton.setAttributedTitle(LocalizedKey.passwordNote.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size16)]), for: .normal)
//        screen.reButton.titleLabel?.numberOfLines = .zero
//        screen.reButton.titleLabel?.lineBreakMode = .byWordWrapping
//        screen.reButton.topAnchor.constraint(equalTo: screen.textfield.bottomAnchor, constant: 20).isActive = true
//        screen.reButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 15).isActive = true
        screen.textfield.isSecureTextEntry = true
        screen.textfield.textContentType = .password
//        screen.completionButton.setTitle(LocalizedKey.toRegister.value, for: .normal)
//        screen.completionButton.setAttributedTitle(LocalizedKey.toRegister.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16)]), for: .normal)
    }
    
    override func bindUI() {
        (screen.textfield<->presenter.password).store(in: &presenter.bag)
    }
    
}

// MARK: - Methods
extension RegisterPasswordController {
    
    private  func validate() {
        if let error = presenter.error.first {
            alert(msg: error.localizedDescription)
            return
        }
        showLoading()
        presenter.register()
//        presenter.trigger.send(.updateProfile(presenter.password.value))
    }
    
}
