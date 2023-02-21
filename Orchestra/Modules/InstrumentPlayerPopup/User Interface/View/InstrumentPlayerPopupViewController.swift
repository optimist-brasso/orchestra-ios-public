//
//  InstrumentPlayerPopupViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import UIKit

class InstrumentPlayerPopupViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: InstrumentPlayerPopupScreen  {
        baseScreen as! InstrumentPlayerPopupScreen
    }
    
    var presenter: InstrumentPlayerPopupModuleInterface?
    private var viewModel: InstrumentPlayerPopupViewModel?
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fixOrientationTo(type: .landscapeRight)
        addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        fixOrientationTo(type: .portrait)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Other Functions
    private func setup() {
        setupButton()
    }
    
    private func setupButton() {
        [screen.closeButton,
         screen.instrumentPlayerView.buyPremiumVideoButton,
         screen.instrumentPlayerView.buyMultiplePartButton,
         screen.instrumentPlayerView.buyButton,
         screen.instrumentPlayerView.addToCartButton,
         screen.instrumentPlayerPremiumView.buyButton,
         screen.instrumentPlayerPremiumView.addToCartButton,
         screen.instrumentPlayerPremiumView.checkAppendixVideoButton].forEach({
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        })
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    private func fixOrientationTo(type: UIInterfaceOrientation) {
        UIDevice.current.setValue(type.rawValue, forKey: "orientation")
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case screen.closeButton:
            presenter?.previousModule()
        case screen.instrumentPlayerView.buyMultiplePartButton:
            presenter?.bulkPurchase()
        case screen.instrumentPlayerView.buyButton,
            screen.instrumentPlayerPremiumView.buyButton:
            if sender == screen.instrumentPlayerPremiumView.buyButton && !(viewModel?.isPartBought ?? false) {
                presenter?.buy(of: .combo)
                return
            }
            presenter?.buy(of: nil)
        case screen.instrumentPlayerView.addToCartButton,
            screen.instrumentPlayerPremiumView.addToCartButton:
            if sender == screen.instrumentPlayerPremiumView.addToCartButton && !(viewModel?.isPartBought ?? false) {
                presenter?.addToCart(of: .combo)
                return
            }
            presenter?.addToCart(of: nil)
        case screen.instrumentPlayerView.buyPremiumVideoButton:
            presenter?.premiumVideoPlayer()
        case screen.instrumentPlayerPremiumView.checkAppendixVideoButton:
            presenter?.appendixVideoPlayer()
        default: break
        }
    }
    
    @objc private func appMovedToForeground() {
        fixOrientationTo(type: .landscapeRight)
    }
    
}

// MARK: InstrumentPlayerPopupViewInterface
extension InstrumentPlayerPopupViewController: InstrumentPlayerPopupViewInterface {
    
    func show(_ model: InstrumentPlayerPopupViewModel) {
        viewModel = model
        screen.viewModel = model
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
}
