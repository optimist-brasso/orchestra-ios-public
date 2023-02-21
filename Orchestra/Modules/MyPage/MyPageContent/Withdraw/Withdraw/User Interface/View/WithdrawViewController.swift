//
//  WithdrawViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//
//

import UIKit

class WithdrawViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: WithdrawScreen  {
        baseScreen as! WithdrawScreen
    }
    
    var presenter: WithdrawModuleInterface?
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Other Functions
    private func setup() {
        setupButton()
    }
    
    private func setupButton() {
        [screen.withdrawButton,
         screen.cancelButton].forEach({
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        })
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case screen.withdrawButton:
            presenter?.confirmation()
        case screen.cancelButton:
            presenter?.previousModule()
        default: break
        }
    }
    
}

// MARK: WithdrawViewInterface
extension WithdrawViewController: WithdrawViewInterface {
    
}
