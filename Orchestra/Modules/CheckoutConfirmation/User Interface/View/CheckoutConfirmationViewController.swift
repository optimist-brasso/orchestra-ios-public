//
//  CheckoutConfirmationViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/06/2022.
//
//

import UIKit

class CheckoutConfirmationViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: CheckoutConfirmationScreen  {
        baseScreen as! CheckoutConfirmationScreen
    }
    
    var presenter: CheckoutConfirmationModuleInterface?
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Other Functions
    private func setup() {
        setupButton()
    }
    
    private func setupButton() {
        [screen.buyButton,
         screen.closeButton].forEach({
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        })
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case screen.buyButton:
            view.endEditing(true)
            presenter?.checkout(with: screen.textfield.text)
        case screen.closeButton,
            screen.cancelButton:
            presenter?.previousModule()
        default: break
        }
    }
    
}

// MARK: CheckoutConfirmationViewInterface
extension CheckoutConfirmationViewController: CheckoutConfirmationViewInterface {
    
}
