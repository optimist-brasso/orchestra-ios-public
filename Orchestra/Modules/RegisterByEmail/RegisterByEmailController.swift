//
//  RegisterByEmailController.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import UIKit
import Combine

class RegisterByEmailController: BaseController {
    private var screen: RegisterByEmailScreen  {
        baseScreen as! RegisterByEmailScreen
    }
    
    private var presenter: RegisterByEmailPresenter  {
        basePresenter as! RegisterByEmailPresenter
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
            self.presenter.trigger.send(.otp)
        }.store(in: &presenter.bag)
        
        
    }
    
    override func observeEvents() {
        presenter.response.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] response in
            guard let self = self else { return }
            self.hideLoading()
            if response.success {
                self.presenter.trigger.send(.otp)
                return
            }
            self.showAlert(message: response.message)
        }.store(in: &presenter.bag)
    }
    
    override func setupUI() {
        screen.reButton.isHidden = true
        screen.textfield.rightImage = nil
        screen.textfield.keyboardType = .emailAddress
        screen.textfield.textContentType = .emailAddress
    }
    
   override  func bindUI() {
        (screen.textfield<->presenter.email).store(in: &presenter.bag)
    }
}

// MARK: - Methods
extension RegisterByEmailController {
    private  func validate() {
        if let error = presenter.error.first {
           alert(msg: error.localizedDescription)
            return
        }
        showLoading()
        presenter.callApi()
    }
}
