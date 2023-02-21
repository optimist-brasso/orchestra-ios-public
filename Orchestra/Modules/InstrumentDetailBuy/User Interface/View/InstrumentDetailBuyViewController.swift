//
//  InstrumentDetailBuyViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import UIKit
import Combine

class InstrumentDetailBuyViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: InstrumentDetailBuyScreen  {
        baseScreen as! InstrumentDetailBuyScreen
    }
    
    var presenter: InstrumentDetailBuyModuleInterface?
    private var bag = Set<AnyCancellable>()
    
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
        [screen.closeButton,
         screen.cancelButton,
         screen.addToCartButton,
         screen.buyButton].forEach({
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        })
        screen.cartButton.publisher(for: .touchUpInside)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.buttonTapped(self.screen.cartButton)
            }.store(in: &bag)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case screen.closeButton,
            screen.cancelButton:
            presenter?.previousModule()
        case screen.addToCartButton:
            presenter?.addToCart()
        case screen.cartButton:
            presenter?.cart()
        case screen.buyButton:
            presenter?.buy()
        default: break
        }
    }
    
}

// MARK: InstrumentDetailBuyViewInterface
extension InstrumentDetailBuyViewController: InstrumentDetailBuyViewInterface {
    
    func show(_ model: InstrumentDetailBuyViewModel) {
        screen.viewModel = model
    }
    
    func showAddedInCart() {
        screen.state = .addedToCart
    }
    
    func showBuySuccess() {
        screen.state = .purchased
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
}
