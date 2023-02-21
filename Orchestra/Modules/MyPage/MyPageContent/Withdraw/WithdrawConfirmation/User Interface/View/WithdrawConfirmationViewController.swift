//
//  WithdrawConfirmationViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//
//

import UIKit

class WithdrawConfirmationViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: WithdrawConfirmationScreen  {
        baseScreen as! WithdrawConfirmationScreen
    }
    
    var presenter: WithdrawConfirmationModuleInterface?
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: Other Functions
    private func setup() {
        [screen.yesButton,
         screen.cancelButton,
         screen.closeButton].forEach({
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        })
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case screen.yesButton:
            presenter?.withdraw()
        case screen.cancelButton:
            presenter?.previousModule()
        case screen.closeButton:
            if screen.state == .initial {
                presenter?.previousModule()
                return
            }
            presenter?.logout()
        default: break
        }
    }
    
}

// MARK: WithdrawConfirmationViewInterface
extension WithdrawConfirmationViewController: WithdrawConfirmationViewInterface {
    
    func showSuccess() {
        screen.state = .withdrawn
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
}
