//
//  BuyViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/04/2022.
//
//

import UIKit

class BuyViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: BuyScreen  {
        baseScreen as! BuyScreen
    }
    
    var presenter: BuyModuleInterface?
    var orchestraType: OrchestraType = .conductor
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Other Functions
    private func setup() {
        setupView()
        setupButton()
    }
    
    private func setupView() {
        view.isUserInteractionEnabled = true
    }
    
    private func setupButton() {
        [screen.closeButton,
         screen.buyButton,
         screen.addToCartButton,
         screen.cancelButton].forEach({
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        })
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case screen.closeButton,
            screen.cancelButton:
            dismiss(animated: true)
        case screen.buyButton:
            presenter?.buy()
        case screen.addToCartButton:
            presenter?.addToCart()
        default: break
        }
    }
    
}

// MARK: BuyViewInterface
extension BuyViewController: BuyViewInterface {
   
    func show(_ model: BuyViewModel) {
        screen.viewModel = model
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
}
