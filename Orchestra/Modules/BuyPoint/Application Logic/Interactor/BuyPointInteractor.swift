//
//  BuyPointInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/09/2022.
//
//

import Foundation
import Combine
import Alamofire

class BuyPointInteractor {
    
    // MARK: Properties
    weak var output: BuyPointInteractorOutput?
    private let service: BuyPointServiceType
    private var models: PointHistory?
    private var disposeBag = Set<AnyCancellable>()
    private var iapProducts = [IAPProduct]()
    private let dispatchGroup = DispatchGroup()
    
    // MARK: Initialization
    init(service: BuyPointServiceType) {
        self.service = service
        observe()
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
    }
    
    // MARK: Converting entities
    //    private func convert(_ models: [Point]) -> [BuyPointStructure] {
    //        models.map({BuyPointStructure(title: $0.title,
    //                                      price: "\(GlobalConstants.currency)\(($0.price ?? .zero).currencyMode)",
    //                                      description: $0.description,
    //                                      image: $0.image)})
    //    }
    
    //MARK: Other functions
    private func observe() {
        IAP.shared.productsFetchResult.receive(on: RunLoop.main).sink { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                if let models = self.models {
                    self.output?.obtained(models)
                }
                
                self.iapProducts = products
            case .failure(let error):
                self.output?.obtained(error)
            }
        }.store(in: &disposeBag)
        IAP.shared.productPurchaseState.sink { [weak self] result in
            switch result {
            case .error(let error):
                self?.output?.obtained(NSError(domain: "payment-error", code: 22, userInfo: [NSLocalizedDescriptionKey: error]))
            default: break
            }
        }.store(in: &disposeBag)
        IAP.shared.finishVerification
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                switch result {
                case .success(_):
//                    self?.service.fetchProfile(completion: { [weak self] result in
//                        switch result {
//                        case .success(_):
//                            self?.output?.obtained(points: (Double(self?.service.points ?? .zero)).currencyMode)
//                        case .failure(_):
//                            break
//                        }
//                        self?.output?.obtainedSuccess(with: LocalizedKey.checkoutSuccessMessage.value)
//                    })
                    
                    self?.getData(showAlert: true)
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }.store(in: &disposeBag)
    }
    
    @objc private func didAddToCart() {
        output?.obtained(cartCount: service.cartCount)
    }
    
    @objc private func didReadNotification() {
        output?.obtained(notificationCount: service.notificationCount)
    }
    
}

// MARK: BuyPoint interactor input interface
extension BuyPointInteractor: BuyPointInteractorInput {
    
    func getData(showAlert: Bool = false) {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
        fetchProducts()
       // fetchProfile()
        dispatchGroup.notify(queue: .main) { [weak self] in
            //            self?.output?.obtainedSuccess(with: nil)
            if let models = self?.models {
                self?.output?.obtained(models)
                if showAlert {
                    self?.output?.obtainedSuccess(with: LocalizedKey.checkoutSuccessMessage.value)
                }
            }
            self?.output?.obtained(points: (Double(self?.service.points ?? .zero)).currencyMode)
        }
    }
    
    func buy(at index: String) {
        if NetworkReachabilityManager()?.isReachable == true {
            IAP.shared.purchase(identifier: index)
        } else {
            output?.obtained(GlobalConstants.Error.noInternet)
        }
//        if   let index = iapProducts.firstIndex(where: {$0.identifier == index}),
//             let iapProduct = iapProducts.element(at: index) {
//            IAP.shared.purchase(product: iapProduct)
//        } else {
//            self.output?.obtained(NSError(domain: "buy-error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.cannotFindBuyProduct.value]))
//        }
    }
    
    private func fetchProducts() {
        dispatchGroup.enter()
        service.fetchPoints { [weak self] result in
            switch result {
            case .success(let models):
                IAP.shared.setProducts(availableProducts: models.bundleList.compactMap({$0.identifier}))
                self?.models = models
                self?.dispatchGroup.leave()
            case .failure(let error):
                self?.output?.obtained(error)
                self?.dispatchGroup.leave()
            }
        }
    }
    
//    private func fetchProfile() {
//        dispatchGroup.enter()
//        service.fetchProfile { [weak self] result in
//            switch result {
//            case .success(_):
//                self?.dispatchGroup.leave()
//            case .failure(_):
//                self?.dispatchGroup.leave()
//            }
//        }
//    }
    
}
