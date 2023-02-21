//
//  ForgotPasswordController.swift
//  Orchestra
//
//  Created by manjil on 18/04/2022.
//

import UIKit
import Combine


class ForgotPasswordController: BaseController {
    
    private var screen: RegisterByEmailScreen  {
        baseScreen as! RegisterByEmailScreen
    }
    
    private var presenter: ForgotPasswordPresenter  {
        basePresenter as! ForgotPasswordPresenter
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
    }
    
    override func observeEvents() {
        presenter.response.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] response in
            guard let self = self else {  return }
                self.hideLoading()
            if response.1 {
                self.presenter.trigger.send(AppRoutable.resetPassword(self.presenter.email.value.trim))
                return
            }
            self.alert(msg: response.0)
        }.store(in: &presenter.bag)
    }
    
    override func setupUI() {
        screen.reButton.isHidden = true
        screen.textfield.rightImage = nil
        screen.textfield.keyboardType = .emailAddress
        screen.textfield.textContentType = .emailAddress
        screen.title.text = LocalizedKey.forgotPasswordTitle.value
        screen.completionButton.setAttributedTitle(LocalizedKey.toReset.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16)]), for: .normal)
    }
    
    override func bindUI() {
        (screen.textfield<->presenter.email).store(in: &presenter.bag)
    }
}


// MARK: - Methods
extension ForgotPasswordController {
    private  func validate() {
        if let error = presenter.error.first {
           alert(msg: error.localizedDescription)
            return
        }
        showLoading()
        presenter.callApi()
    }
}
