//
//  BulkInstrumentBuyConfirmationInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 21/06/2022.
//
//

import Foundation
import Combine

class BulkInstrumentBuyConfirmationInteractor {
    
	// MARK: Properties
    weak var output: BulkInstrumentBuyConfirmationInteractorOutput?
    private let service: BulkInstrumentBuyConfirmationServiceType
    private var models: [Instrument]?
    private var model: Instrument?
    var sessionType = SessionType.part
    var id: Int?
    var successState = false
    private var disposeBag = Set<AnyCancellable>()
    private var iapProducts = [IAPProduct]()
    
    // MARK: Initialization
    init(service: BulkInstrumentBuyConfirmationServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didGetInstruments(_:)), name: GlobalConstants.Notification.getInstrument.notificationName, object: nil)
    }

    // MARK: Other functions
    @objc private func didGetInstruments(_ notification: Notification) {
        if let models = notification.object as? [Instrument] {
            models.forEach({
                let orchestra = Orchestra()
                orchestra.id = id
                $0.orchestra = orchestra
            })
            self.models = models
            sendSuccessData()
        } else if let model = notification.object as? Instrument {
            self.model = model
            output?.obtained(title: model.orchestra?.title, japaneseTitle: model.orchestra?.titleJapanese)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: InstrumentBuy interactor input interface
extension BulkInstrumentBuyConfirmationInteractor: BulkInstrumentBuyConfirmationInteractorInput {
    
    func getData() {
        output?.obtained(title: model?.orchestra?.title, japaneseTitle: model?.orchestra?.titleJapanese)
        sendSuccessData()
    }
    
    func buy() {
        guard !(models?.isEmpty ?? false) else {
            output?.obtained(NSError(domain: "buy-bulk-error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.instrumentPurchaseMinError.value]))
            return
        }
        let cartItems: [CartItem] = models?.map({
            let cartItem = $0.getCartItem(of: sessionType)
            cartItem.orchestraId = id
            if cartItem.id == nil, let relatedItems = model?.cartItems {
                switch sessionType {
                case .part:
                    if let index = relatedItems.firstIndex(where: {$0.sessionType == SessionType.combo.rawValue}) {
                        cartItem.id = relatedItems.element(at: index)?.id
                    }
                case .combo:
                    if let index = relatedItems.firstIndex(where: {$0.sessionType == SessionType.part.rawValue}) {
                        cartItem.id = relatedItems.element(at: index)?.id
                    }
                default: break
                }
            }
            return cartItem
        }) ?? []
//        guard cartItems.count == 1 else {
//            output?.obtained(NSError(domain: "buy-error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.instrumentPurchaseMaxError.value]))
//            return
//        }
        service.checkout(items: cartItems) { [weak self] result in
            switch result {
            case .success(_):
                self?.output?.obtained(true, total: "\(cartItems.count)\(LocalizedKey.songs.value)")
            case .failure(let error):
                self?.output?.obtained(error)
            }
        }
    }
    
    func addToCart() {
        guard !(models?.isEmpty ?? false) else {
            output?.obtained(NSError(domain: "add-to-cart-error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.instrumentAddToCartMinError.value]))
            return
        }
        let cartItems: [CartItem] = models?.map({
            let item = $0.getCartItem(of: self.sessionType)
            item.orchestraId = id
            item.sessionType = SessionType.part.rawValue
            return item
        }) ?? []
        service.addToCart(items: cartItems) { [weak self] result in
            switch result {
            case .success(_):
//                let total: Double = cartItems.reduce(0) { $0 + ($1.price ?? .zero)}
                self?.output?.obtained(false, total: "\(cartItems.count)\(LocalizedKey.songs.value)")
            case .failure(let error):
                self?.output?.obtained(error)
            }
        }
//        output?.obtained(false, total: "\(cartItems.count)\(LocalizedKey.songs.value)")
    }
    
    private func sendSuccessData() {
        if successState {
            let cartItems: [CartItem] = models?.map({
                let item = $0.getCartItem(of: self.sessionType)
                item.orchestraId = id
                item.sessionType = SessionType.part.rawValue
                return item
            }) ?? []
//            let total: Double = cartItems.reduce(0) { $0 + ($1.price ?? .zero)}
            output?.obtained(false, total: "\(cartItems.count)\(LocalizedKey.songs.value)")
        }
    }
    
    func cart() {
        GlobalConstants.Notification.openCart.fire()
    }
    
}
