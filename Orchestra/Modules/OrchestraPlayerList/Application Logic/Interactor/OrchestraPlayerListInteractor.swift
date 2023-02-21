//
//  OrchestraPlayerListInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/07/2022.
//
//

import Foundation

class OrchestraPlayerListInteractor {
    
    // MARK: Properties
    weak var output: OrchestraPlayerListInteractorOutput?
    private let service: OrchestraPlayerListServiceType
    var id: Int?
    private var page: Int = 1
    private var hasMoreData = true
    private var isLoading = false
    private var models = [Musician]()
    
    // MARK: Initialization
    init(service: OrchestraPlayerListServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
    }
    
    // MARK: Converting entities
    private func convert(_ models: [Musician]) -> [OrchestraPlayerListStructure] {
        return models.map({OrchestraPlayerListStructure(id: $0.id,
                                                        name: $0.name,
                                                        instrument: $0.instrument?.name,
                                                        image: $0.image)})
    }
    
    //MARK: Other functions
    @objc private func didAddToCart() {
        output?.obtained(cartCount: service.cartCount)
    }
    
    @objc private func didReadNotification() {
        output?.obtained(notificationCount: service.notificationCount)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: OrchestraPlayerList interactor input interface
extension OrchestraPlayerListInteractor: OrchestraPlayerListInteractorInput {
    
    func getData(isRefresh: Bool) {
        if let id = id {
            if isRefresh {
                hasMoreData = true
                isLoading = false
                page = 1
                models.removeAll()
                output?.obtained(cartCount: service.cartCount)
                output?.obtained(notificationCount: service.notificationCount)
            }
            if !isLoading && hasMoreData {
                isLoading = true
                service.fetchPlayerList(of: page, id: id) { [weak self] result in
                    switch result {
                    case .success((let models, let totalPages)):
                        self?.isLoading = false
                        self?.page += 1
                        self?.hasMoreData = (self?.page ?? .zero) <= totalPages
                        self?.output?.obtained(self?.hasMoreData ?? true)
                        self?.models.append(contentsOf: models.shuffled())
                        self?.output?.obtained(self?.convert(self?.models ?? []) ?? [])
                    case .failure(let error):
                        self?.isLoading = false
                        self?.output?.obtained(error)
                    }
                }
            }
        }
    }
    
    func getLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
}
