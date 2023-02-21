//
//  OrchestraListingInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

import Foundation

class OrchestraListingInteractor {
    
	// MARK: Properties
    weak var output: OrchestraListingInteractorOutput?
    private let service: OrchestraListingServiceType
    private var page: Int = 1
    private var hasMoreData: Bool = true
    private var isLoading: Bool = false
    private var models = [Orchestra]()
    
    // MARK: Initialization
    init(service: OrchestraListingServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
    }

    // MARK: Converting entities
    private func convert(_ models: [Orchestra]) -> [OrchestraListingStructure] {
        return models.map({
            return OrchestraListingStructure(id: $0.id,
                                             title: $0.title,
                                             titleJapanese: $0.titleJapanese,
                                             releaseDate: $0.releaseDate,
                                             duration: $0.duration?.time,
                                             image: $0.image,
                                             conductorImage: $0.conductorImage,
                                             sessionImage: $0.sessionImage,venueDiagram: $0.venueDiagram)
        })
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

// MARK: OrchestraListing interactor input interface
extension OrchestraListingInteractor: OrchestraListingInteractorInput {
    
    func getData(isRefresh: Bool) {
        func getData() {
            service.fetchOrchestraList(of: page) { [weak self] result in
                switch result {
                case .success((let models, let totalPages)):
                    self?.isLoading = false
                    self?.page += 1
                    self?.hasMoreData = (self?.page ?? .zero) <= totalPages
//                    self?.output?.obtained(hasMoreData: self?.hasMoreData ?? false)
                    self?.models.append(contentsOf: models)
                    self?.output?.obtained(self?.convert(self?.models ?? []) ?? [])
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        }
        
        if isRefresh {
            output?.obtained(cartCount: service.cartCount)
            output?.obtained(notificationCount: service.notificationCount)
            hasMoreData = true
            isLoading = false
            page = 1
            models.removeAll()
        }
        if !isLoading && hasMoreData {
            isLoading = true
            if page == 1 {
                service.getNotificationList { [weak self] _ in
                    self?.output?.obtained(notificationCount: self?.service.notificationCount ?? .zero)
                    getData()
                }
            } else {
                getData()
            }
        }
        if service.isLoggedIn {
            service.fetchPoints { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let point):
                    self.output?.obtained(point: point)
                case .failure(_):
                    self.output?.obtained(point: nil)
                }
            }
        } else {
            output?.obtained(point: nil)
        }
    }
    
    func search(for keyword: String) {
        service.search(for: keyword) { [weak self] result in
            switch result {
            case .success(let models):
                self?.output?.obtained(self?.convert(models) ?? [])
            case .failure(let error):
                self?.output?.obtained(error)
            }
        }
    }
    
    func getLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
}
