//
//  ChangePasswordController.swift
//  Orchestra
//
//  Created by manjil on 15/04/2022.
//

import UIKit
import Combine

class ChangePasswordController: BaseController {
    private var screen: ChangePasswordScreen  {
        baseScreen as! ChangePasswordScreen
    }
    
    private var presenter: ChangePasswordPresenter  {
        basePresenter as! ChangePasswordPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func observerScreen() {
        screen.cancelButton.publisher(for: .touchUpInside).receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &presenter.bag)
        
        screen.changeButton.publisher(for: .touchUpInside).receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] _ in
            self?.validateAndCallApi()
        }.store(in: &presenter.bag)
    }
    
    override func observeEvents() {
        presenter.service.response.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] response in
            guard let self = self else { return }
            self.hideLoading()
                self.alert(msg: response.0) { _ in
                if response.1 {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }.store(in: &presenter.bag)
    }
    
    override func bindUI() {
        (screen.oldPassword.textfield<->presenter.oldPassword).store(in: &presenter.bag)
        (screen.newPassword.textfield<->presenter.newPassword).store(in: &presenter.bag)
        (screen.confirmPassword.textfield<->presenter.confirmPassword).store(in: &presenter.bag)
    }
}

extension ChangePasswordController {
    
    private func validateAndCallApi() {
        if let error = presenter.error.first {
            self.alert(msg: error.localizedDescription)
            return
        } else if screen.newPassword.textfield.text != screen.confirmPassword.textfield.text {
            self.alert(msg: LocalizedKey.newAndConfirmPasswordSame.value)
            return
        }
        showLoading()
        presenter.service.changePassword(new: presenter.newPassword.value, old: presenter.oldPassword.value)
        
    }
}
