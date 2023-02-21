//
//  CartInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/05/2022.
//
//

import Foundation
import Combine

class CartInteractor {
    
	// MARK: Properties
    weak var output: CartInteractorOutput?
    private let service: CartServiceType
    private var page: Int = 1
    private var hasMoreData: Bool = true
    private var isLoading: Bool = false
    private var models = [CartItem]()
    private var selectedIndex: Int?
    private var disposeBag = Set<AnyCancellable>()
    private var iapProducts = [IAPProduct]()
    
    // MARK: Initialization
    init(service: CartServiceType) {
        self.service = service
    }

    // MARK: Converting entities
    private func convert(_ models: [CartItem]) -> [CartStructure] {
        return models.map({CartStructure(type: OrchestraType(rawValue: $0.orchestraType ?? ""),
                                         sessionType: SessionType(rawValue: $0.sessionType ?? ""),
                                         isPremium: $0.isPremium,
                                         title: $0.title,
                                         titleJapanese: $0.titleJapanese,
                                         price: $0.price,
                                         instrument: $0.instrument,
                                         musician: $0.musician,
                                         isSelected: $0.isSelected)})
    }
    
}

// MARK: Cart interactor input interface
extension CartInteractor: CartInteractorInput {
    func sendData() {
        
    }
    
    
    func getData(isRefresh: Bool) {
        func getData() {
            service.fetchCartList(of: page) { [weak self] result in
                switch result {
                case .success((let models, let totalPages)):
                    self?.isLoading = false
                    self?.page += 1
                    self?.hasMoreData = (self?.page ?? .zero) <= totalPages
                    self?.output?.obtained(self?.hasMoreData ?? false)
                    self?.models.append(contentsOf: models)
                    self?.output?.obtained(self?.convert(self?.models ?? []) ?? [])
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        }
        
        if isRefresh {
            hasMoreData = true
            isLoading = false
            page = 1
            models.removeAll()
            output?.obtained(service.notificationCount)
        }
        if !isLoading && hasMoreData {
            isLoading = true
            if page == 1 {
                service.getNotificationList { [weak self] _ in
                    self?.output?.obtained(self?.service.notificationCount ?? .zero)
                    getData()
                }
            } else {
                getData()
            }
        }
    }
    
    func remove(at index: Int) {
        if let id = models.element(at: index)?.id {
            service.deleteCartItem(of: id) { [weak self] result in
                switch result {
                case .success(_):
                    self?.models.remove(at: index)
                    self?.output?.obtained(self?.convert(self?.models ?? []) ?? [])
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        } else {
            output?.obtained(EK_GlobalConstants.Error.oops)
        }
    }

    func select(at index: Int) {
//        selectedIndex = index
        models.element(at: index)?.isSelected.toggle()
        output?.obtained(convert(models))
    }
    
    func buy(withConfirmation: Bool) {
        let selectedItems = models.filter({$0.isSelected})
        guard !selectedItems.isEmpty else {
            output?.obtained(NSError(domain: "buy-error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.checkoutMinError.value]))
            return
        }
//        guard selectedItems.count == 1 else {
//            output?.obtained(NSError(domain: "buy-error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.instrumentPurchaseMaxError.value]))
//            return
//        }
        guard !withConfirmation else {
            output?.obtainedCheckoutConfirmationNeed()
            return
        }
        service.checkout(items: selectedItems) { [weak self] result in
            switch result {
            case .success(_):
                self?.models = self?.models.filter({!$0.isSelected}) ?? []
                self?.output?.obtained(self?.convert(self?.models ?? []) ?? [])
                self?.output?.obtainedSuccess(with: LocalizedKey.checkoutSuccessMessage.value)
            case .failure(let error):
                self?.output?.obtained(error)
            }
        }
    }
    
}
