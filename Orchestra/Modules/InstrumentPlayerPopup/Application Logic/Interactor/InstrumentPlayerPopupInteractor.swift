//
//  InstrumentPlayerPopupInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import Foundation
import Combine

class InstrumentPlayerPopupInteractor {
    
	// MARK: Properties
    weak var output: InstrumentPlayerPopupInteractorOutput?
    private let service: InstrumentPlayerPopupServiceType
    var type: SessionType = .part
    var orchestraId: Int?
    private var model: Instrument?
    private var models: [SessionLayout]?
    private var disposeBag = Set<AnyCancellable>()
    
    // MARK: Initialization
    init(service: InstrumentPlayerPopupServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didGetInstrument(_:)), name: GlobalConstants.Notification.getInstrument.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetSessionLayout(_:)), name: GlobalConstants.Notification.getSessionLayout.notificationName, object: nil)
    }
    
    //MARK: Converting functions
    private func convert(_ model: Instrument) -> InstrumentPlayerPopupStructure {
        return InstrumentPlayerPopupStructure(isPartBought: model.isPartBought,
                                              isPremiumBought: model.isPremiumBought)
    }

    // MARK: Other functions
    @objc private func didGetInstrument(_ notification: Notification) {
        if let model = notification.object as? Instrument {
            self.model = model
            getData()
        }
    }
    
    @objc private func didGetSessionLayout(_ notification: Notification) {
        if models == nil, let models = notification.object as? [SessionLayout] {
            self.models = models
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: InstrumentPlayerPopup interactor input interface
extension InstrumentPlayerPopupInteractor: InstrumentPlayerPopupInteractorInput {
    
    func getData() {
        if let model = model {
            output?.obtained(convert(model))
        }
    }
    
    func sendData() {
        if let model = model {
            GlobalConstants.Notification.getInstrument.fire(withObject: model)
            GlobalConstants.Notification.getSessionLayout.fire(withObject: models)
        }
    }
    
    func addToCart(of type: SessionType?) {
        if let item = model?.getCartItem(of: type ?? self.type) {
            item.orchestraId = orchestraId
            item.musicianId = model?.musician?.id
            service.addToCart(items: [item]) { [weak self] result in
                switch result {
                case .success(_):
                    self?.output?.obtainedSuccess()
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        }
    }
    
    func buy(of type: SessionType?) {
        if let item = model?.getCartItem(of: type ?? self.type) {
            item.orchestraId = orchestraId
            item.musicianId = model?.musician?.id
            if item.id == nil, let relatedItems = model?.cartItems {
                switch type ?? self.type {
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
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.output?.obtainedSuccess()
                case .failure(let error):
                    self.output?.obtained(error)
                }
            }
        }
    }
    
}
