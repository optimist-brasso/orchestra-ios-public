//
//  ResetPasswordController.swift
//  Orchestra
//
//  Created by manjil on 18/04/2022.
//

import UIKit
import Combine

class ResetPasswordController: BaseController {
    private var screen: ResetPasswordScreen  {
        baseScreen as! ResetPasswordScreen
    }
    
    private var presenter: ResetPasswordPresenter  {
        basePresenter as! ResetPasswordPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func observerScreen() {
        screen.changeButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            guard let self = self else { return }
            self.view.endEditing(true)
            self.validate()
        }.store(in: &presenter.bag)
    }
    
    override func observeEvents() {
        presenter.response.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] response in
            guard let self = self else {  return }
                self.hideLoading()
            self.alert(msg: response.0) { _ in
                if response.1 {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }.store(in: &presenter.bag)
    }
    
    
    override func bindUI() {
        (screen.token.textfield<->presenter.otp).store(in: &presenter.bag)
        (screen.newPassword.textfield<->presenter.password).store(in: &presenter.bag)
    }
    
}

// MARK: - Methods
extension ResetPasswordController {
    private  func validate() {
        if let error = presenter.error.first {
           alert(msg: error.localizedDescription)
            return
        }
        showLoading()
        presenter.callApi()
    }
}
