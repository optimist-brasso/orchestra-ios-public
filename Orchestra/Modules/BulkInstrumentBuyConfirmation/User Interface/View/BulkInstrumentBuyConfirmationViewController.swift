//
//  InstrumentBuyViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 21/06/2022.
//
//

import UIKit

class BulkInstrumentBuyConfirmationViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: BulkInstrumentBuyConfirmationScreen  {
        baseScreen as! BulkInstrumentBuyConfirmationScreen
    }
    
    var presenter: BulkInstrumentBuyConfirmationModuleInterface?
    var successState: Bool = false
    private var isBuySuccess = false
    
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
        setupButton()
    }
    
    private func setupButton() {
        [screen.confirmationView.closeButton,
         screen.confirmationView.addToCartButton,
         screen.confirmationView.buyButton,
         screen.successView.nextButton,
         screen.successView.closeButton].forEach({
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        })
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case screen.confirmationView.buyButton:
            presenter?.buy()
        case screen.confirmationView.addToCartButton:
            presenter?.addToCart()
        case screen.confirmationView.closeButton:
            presenter?.previousModule()
        case screen.successView.nextButton:
            if isBuySuccess {
                presenter?.previousModule()
                return
            }
            presenter?.cart()
        case screen.successView.closeButton:
            presenter?.previousModule()
        default: break
        }
    }
    
}

// MARK: InstrumentBuyViewInterface
extension BulkInstrumentBuyConfirmationViewController: BulkInstrumentBuyConfirmationViewInterface {
    
    func show(title: String?, japaneseTitle: String?) {
        screen.successView.titleLabel.text = title
        screen.successView.japaneseTitleLabel.text = japaneseTitle
    }
    
    func show(_ buySuccess: Bool, total: String) {
        screen.confirmationView.isHidden = true
        screen.successView.isBuySuccess = buySuccess
        isBuySuccess = buySuccess
        screen.successView.priceLabel.text = total
        screen.successView.isHidden = false
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
}
