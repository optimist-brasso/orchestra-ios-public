//
//  PlayerListingInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

import Foundation

class PlayerListingInteractor {
    
	// MARK: Properties
    weak var output: PlayerListingInteractorOutput?
    private let service: PlayerListingServiceType
    private var page: Int = 1
    private var hasMoreData = true
    private var isLoading = false
    private var models = [Musician]()
    private var keyword: String?
    
    // MARK: Initialization
    init(service: PlayerListingServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
    }

    // MARK: Converting entities
    private func convert(_ models: [Musician]) -> [PlayerListingStructure] {
        return models.map({PlayerListingStructure(id: $0.id,
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

// MARK: PlayerListing interactor input interface
extension PlayerListingInteractor: PlayerListingInteractorInput {
    
    func getData(isRefresh: Bool, keyword: String?) {
        func getData() {
            service.fetchPlayerList(of: page, keyword: self.keyword) { [weak self] result in
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
        
        if let keyword = keyword, self.keyword != keyword {
            self.keyword = keyword
        }
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
    
    func getLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
}
