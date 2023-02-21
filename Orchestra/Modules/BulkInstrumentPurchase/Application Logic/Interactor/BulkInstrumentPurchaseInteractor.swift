//
//  BulkInstrumentPurchaseInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/06/2022.
//
//

import Foundation

class BulkInstrumentPurchaseInteractor {
    
    // MARK: Properties
    weak var output: BulkInstrumentPurchaseInteractorOutput?
    private let service: BulkInstrumentPurchaseServiceType
    var id: Int? //Orchestra-id
    var instrumentId: Int?
    var musicianId: Int?
    private var model: Instrument?
    private var models: [Instrument]?
    var type: SessionType = .part
    private var sessionLayoutModels: [SessionLayout]?
    
    // MARK: Initialization
    init(service: BulkInstrumentPurchaseServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetInstrument(_:)), name: GlobalConstants.Notification.getInstrument.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBuy(_:)), name: GlobalConstants.Notification.didBuy.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetSessionLayout(_:)), name: GlobalConstants.Notification.getSessionLayout.notificationName, object: nil)
    }
    
    //MARK: Converting functions
    private func convert(_ models: [Instrument]) -> [BulkInstrumentPurchaseStructure] {
        return models.map({BulkInstrumentPurchaseStructure(id: $0.id,
                                                           musician: $0.musician?.name,
                                                           image: $0.musician?.image,
                                                           instrument: $0.name,
                                                           isPartBought: $0.isPartBought,
                                                           isPremiumBought: $0.isPremiumBought)})
    }
    
    //MARK: Other functions
    @objc private func didAddToCart() {
        output?.obtained(cartCount: service.cartCount)
    }
    
    @objc private func didReadNotification() {
        output?.obtained(notificationCount: service.notificationCount)
    }
    
    @objc private func didGetInstrument(_ notification: Notification) {
        if let model = notification.object as? Instrument {
            self.model = model
        }
    }
    
    @objc private func didBuy(_ notification: Notification) {
        if let models = models, let purchasedItems = notification.object as? [CartItem] {
            models.forEach({
                if let musicianId = $0.musician?.id,
                   let orchestraId = id,
                   purchasedItems.contains(where: {musicianId == $0.musicianId &&
                       orchestraId == $0.orchestraId &&
                       ($0.sessionType == SessionType.part.rawValue || $0.sessionType == SessionType.combo.rawValue) &&
                       $0.orchestraType == OrchestraType.session.rawValue}) {
                    $0.isPartBought = true
                    if self.type == .combo || self.type == .premium {
                        $0.isPremiumBought = true
                    }
                    $0.isSelected = false
                }
            })
            output?.obtained(convert(models))
        }
    }
    
    @objc private func didGetSessionLayout(_ notification: Notification) {
        if sessionLayoutModels == nil, let models = notification.object as? [SessionLayout] {
            self.sessionLayoutModels = models
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: BulkInstrumentPurchase interactor input interface
extension BulkInstrumentPurchaseInteractor: BulkInstrumentPurchaseInteractorInput {
    
    func getData() {
        output?.obtained(title: model?.orchestra?.title, japaneseTitle: model?.orchestra?.titleJapanese)
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
        if let id = id {
            service.fetchOrchestraInstrument(of: id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let models):
                    self.models =  models
//                    self.models = [Instrument]()
//                    self.sessionLayoutModels?.forEach({ sessionLayout in
//                        if let index = models.firstIndex(where: {$0.id == sessionLayout.instrumentId && $0.player?.id == sessionLayout.musicianId}),
//                           let instrument = models.element(at: index) {
//                            self.models?.append(instrument)
//                        }
//                    })
//                    if (self.sessionLayoutModels?.isEmpty ?? true) {
//                        self.models =  models
////                        if let index = models.firstIndex(where: {$0.id == self.instrumentId && $0.player?.id == self.musicianId}),
////                           let instrument = models.element(at: index) {
////                            self.models?.append(instrument)
////                        }
//                    }
                    self.output?.obtained(self.convert(self.models ?? []))
                case .failure(let error):
                    self.output?.obtained(error)
                }
            }
        }
    }
    
    func buy() {
        let selectedItems = models?.filter({$0.isSelected}) ?? []
        guard !selectedItems.isEmpty else {
            output?.obtained(NSError(domain: "buy-error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.instrumentPurchaseMinError.value]))
            return
        }
        //        guard selectedItems.count == 1 else {
        //            output?.obtained(NSError(domain: "buy-error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.instrumentPurchaseMaxError.value]))
        //            return
        //        }
        output?.obtainedConfirmationNeed()
    }
    
    func sendData() {
        let selectedItems = models?.filter({$0.isSelected}) ?? []
        GlobalConstants.Notification.getInstrument.fire(withObject: selectedItems)
        GlobalConstants.Notification.getInstrument.fire(withObject: model)
    }
    
    func select(at index: Int) {
        models?.element(at: index)?.isSelected.toggle()
    }
    
    func addToCart() {
        let selectedItems = models?.filter({$0.isSelected}) ?? []
        guard !selectedItems.isEmpty else {
            output?.obtained(NSError(domain: "add-to-cart-error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.instrumentAddToCartMinError.value]))
            return
        }
        let cartItems: [CartItem] = selectedItems.map({
            let item = $0.getCartItem(of: type)
            item.orchestraId = id
            return item
        })
        service.addToCart(items: cartItems) { [weak self] result in
            switch result {
            case .success(_):
                self?.output?.obtainedSuccess()
            case .failure(let error):
                self?.output?.obtained(error)
            }
        }
    }
    
}
