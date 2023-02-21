//
//  BuyInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/04/2022.
//
//

import Foundation
import Combine

class BuyInteractor {
    
	// MARK: Properties
    weak var output: BuyInteractorOutput?
    private let service: BuyServiceType
    var orchestraType: OrchestraType = .conductor
    var id: Int?
    var model: Orchestra?
    private var disposeBag = Set<AnyCancellable>()
    private var iapProducts = [IAPProduct]()
    
    // MARK: Initialization
    init(service: BuyServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didGetBuy(_:)), name: GlobalConstants.Notification.didBuy.notificationName, object: nil)
    }

    // MARK: Converting entities
    private func convert(_ model: Orchestra) -> BuyStructure {
        return BuyStructure(title: model.title,
                            titleJapanese: model.titleJapanese,
                            venue: model.venueTitle,
                            price: "\((model.hallsoundPrice ?? .zero).currencyMode) \(LocalizedKey.points.value)")
    }
    
    //MARK: Other functions
    @objc private func didGetBuy(_ notification: Notification) {
        if let model = notification.object as? Orchestra {
            self.model = model
            output?.obtained(convert(model))
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: Buy interactor input interface
extension BuyInteractor: BuyInteractorInput {
    
    func getData() {
        if let model = self.model {
            output?.obtained(convert(model))
        }
    }
    
    func buy() {
        var item = CartItem()
        if orchestraType == .hallSound,
           let id = id,
           let cartItem = service.fetchHallSoundCartItem(of: id) {
            item = cartItem
        } else {
            item.orchestraId = model?.id
            item.orchestraType = orchestraType.rawValue
            item.price = model?.hallsoundPrice
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
    
    func addToCart() {
        if let model = model,
           let id = model.id {
            let model = CartItem()
            model.orchestraId = id
            model.orchestraType = orchestraType.rawValue
            model.price = self.model?.hallsoundPrice
            service.addToCart(items: [model]) { [weak self] result in
                switch result {
                case .success(_):
                    self?.output?.obtainedSuccess()
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        } else {
            output?.obtained(EK_GlobalConstants.Error.oops)
        }
    }
    
}
