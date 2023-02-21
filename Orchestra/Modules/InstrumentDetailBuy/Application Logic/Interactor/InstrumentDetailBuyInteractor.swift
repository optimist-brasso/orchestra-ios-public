//
//  InstrumentDetailBuyInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import Foundation
import Combine

class InstrumentDetailBuyInteractor {
    
	// MARK: Properties
    weak var output: InstrumentDetailBuyInteractorOutput?
    private let service: InstrumentDetailBuyServiceType
    private var model: Instrument?
    var orchestraId: Int?
    var type: SessionType?
    private var disposeBag = Set<AnyCancellable>()
    private var iapProducts = [IAPProduct]()
    
    // MARK: Initialization
    init(service: InstrumentDetailBuyServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didGetInstrument(_:)), name: GlobalConstants.Notification.getInstrument.notificationName, object: nil)
    }

    // MARK: Converting entities
    private func convert(_ model: Instrument) -> InstrumentDetailBuyStructure {
        var price: Double?
        var typeString: String?
        if let type = type {
            switch type {
            case .part:
                price = model.partPrice
                typeString = type.title
            case .premium:
                price = model.premiumPrice
                typeString = type.title
            case .combo:
                price = model.comboPrice
                typeString = "\(SessionType.part.title ?? "")"
            default: break
            }
        }
        return InstrumentDetailBuyStructure(title: "\(model.orchestra?.title ?? "")/\n\(model.orchestra?.titleJapanese ?? "")",
                                            type: "\(typeString ?? "")\(type == .premium ? "\n" : "")【\(model.name ?? "")】\(type == .combo ? "\n+\n\(LocalizedKey.premiumVideo.value)" : "")",
                                            price: "\((price ?? .zero).currencyMode) \(LocalizedKey.points.value)",
                                            sessionType: type)
    }
    
    //MARK: Other functions
    @objc private func didGetInstrument(_ notification: Notification) {
        if let model = notification.object as? Instrument {
            self.model = model
            output?.obtained(convert(model))
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: InstrumentDetailBuy interactor input interface
extension InstrumentDetailBuyInteractor: InstrumentDetailBuyInteractorInput {
    
    func getData() {
        if let model = model {
            output?.obtained(convert(model))
        }
    }
    
    func addToCart() {
        if let type = type, let item = model?.getCartItem(of: type) {
            item.orchestraId = orchestraId
            item.sessionType = type.rawValue
            item.musicianId = model?.musician?.id
            service.addToCart(items: [item]) { [weak self] result in
                switch result {
                case .success(_):
                    self?.output?.obtainedAddedInCart()
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        }
    }
    
    func buy() {
        if let type = type, let item = model?.getCartItem(of: type) {
            item.orchestraId = orchestraId
            item.sessionType = type.rawValue
            if item.id == nil, let relatedItems = model?.cartItems {
                switch type {
                case .part:
                    if let index = relatedItems.firstIndex(where: {$0.sessionType == SessionType.combo.rawValue}) {
                        item.id = relatedItems.element(at: index)?.id
                    }
                case .combo:
                    if let index = relatedItems.firstIndex(where: {$0.sessionType == SessionType.part.rawValue}) {
                        item.id = relatedItems.element(at: index)?.id
                    }
                default: break
                }
            }
            service.checkout(items: [item]) { [weak self] result in
                switch result {
                case .success(_):
                    self?.output?.obtainedBuySuccess()
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        }
    }
    
    func cart() {
        GlobalConstants.Notification.openCart.fire()
    }
    
}
