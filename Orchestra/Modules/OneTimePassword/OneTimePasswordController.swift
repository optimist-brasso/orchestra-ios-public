//
//  OneTimePasswordController.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import UIKit

class OneTimePasswordController: BaseController {
    
    private var screen: RegisterByEmailScreen  {
        baseScreen as! RegisterByEmailScreen
    }
    
    private var presenter: OneTimePasswordPresenter  {
        basePresenter as! OneTimePasswordPresenter
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
        screen.reButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            guard let self = self else { return }
            self.view.endEditing(true)
            self.resendApiCall()
        }.store(in: &presenter.bag)
    }
    
    override func observeEvents() {
        presenter.response.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] response in
            guard let self = self else { return }
            self.hideLoading()
            if response.success, case AuthRouter.tokenVerification = response.router {
                self.presenter.trigger.send(.registerPassword)
                return
            }
            self.showAlert(message: response.message)
        }.store(in: &presenter.bag)
    }
    
    override func setupUI() {
        screen.reButton.isHidden = false
        screen.subTitle.text = LocalizedKey.oneTimePassword.value
        screen.reButton.setAttributedTitle(LocalizedKey.resendOTP.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size16)]), for: .normal)
        screen.textfield.rightImage = nil
        screen.textfield.textContentType = .oneTimeCode
        screen.completionButton.setAttributedTitle(LocalizedKey.completeTheInput.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16)]), for: .normal)
        screen.email.text = "\(LocalizedKey.emailPlaceholder.value): \(Cacher().get(String.self, forKey: .email) ?? "")"
        screen.email.isHidden = false
        screen.textfield.attributedPlaceholder = LocalizedKey.pleaseEnterYourOTP.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16), .foregroundColor: UIColor.placeholder])
    }
    
     override func bindUI() {
        (screen.textfield<->presenter.otp).store(in: &presenter.bag)
    }
    
}

// MARK: - Methods
extension OneTimePasswordController {
    
    private  func validate() {
        if let error = presenter.error.first {
            alert(msg: error.localizedDescription)
            return
        }
        showLoading()
        presenter.callApi()
    }
    
    private func resendApiCall() {
        if let email = Cacher().get(String.self, forKey: .email) {
            showLoading()
            presenter.callResendApi(email: email)
        }
    }
    
}
