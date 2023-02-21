//
//  HomeInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//
//

import Foundation

class HomeInteractor {
    
    // MARK: Properties
    weak var output: HomeInteractorOutput?
    private let service: HomeServiceType
    private var page: Int = 1
    private var hasMoreData: Bool = true
    private var isLoading: Bool = false
    
    // MARK: Initialization
    init(service: HomeServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
    }
    
    // MARK: Converting entities
    private func convert(_ models: [Banner]) -> [HomeBannerStructure] {
        models.map({HomeBannerStructure(image: $0.image,
                                        title: $0.title,
                                        description: $0.link?.description,
                                        url: $0.link?.url)})
    }
    
    private func convert(_ models: [Orchestra]) -> [HomeRecommendationStructure] {
        models.map({
            //            let tags = Array($0.tags) as? [String]
            return HomeRecommendationStructure(id: $0.id,
                                               title: $0.title,
                                               titleJapanese: $0.titleJapanese,
                                               image: $0.image,
                                               duration: $0.duration?.time,
                                               releaseDate: $0.releaseDate,
                                               tags: $0.tags)})
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

// MARK: Home interactor input interface
extension HomeInteractor: HomeInteractorInput {
    
    func getData(isRefresh: Bool) {
        func fetchHome() {
            service.fetchHome { [weak self] result in
                switch result {
                case .success(let modelTuple):
                    if self?.page == 1 {
                        self?.output?.obtained(models: self?.convert(modelTuple.model.banners ?? []) ?? [])
                    }
                    self?.isLoading = false
                    self?.page += 1
                    self?.hasMoreData = (self?.page ?? .zero) <= (modelTuple.totalPages)
                    self?.sort(modelTuple.model.recommendations ?? [])
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        }
        
        if isRefresh {
            hasMoreData = true
            isLoading = false
            page = 1
            output?.obtained(cartCount: service.cartCount)
            output?.obtained(notificationCount: service.notificationCount)
        }
        if !isLoading && hasMoreData {
            isLoading = true
            if page == 1 {
                service.getNotificationList { [weak self] _ in
                    self?.output?.obtained(notificationCount: self?.service.notificationCount ?? .zero)
                    fetchHome()
                }
            } else {
                fetchHome()
            }
        }
        
        if service.isLoggedIn {
            service.fetchPoints { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let point):
                    self.output?.obtained(point: point)
                case .failure(let error):
                    print(error.localizedDescription)
                    self.output?.obtained(point: nil)
                }
            }
        } else {
            output?.obtained(point: nil)
        }
    }
    
    private func sort(_ models: [Orchestra]) {
        var prModels = models.filter { model in
            //pr sorted at first before any tags
            //            var tags = Array(model.tags)
            model.tags?.enumerated().forEach({
                if $0.element.lowercased() == "pr" {
                    model.tags?.swapAt(.zero, $0.offset)
                }
            })
            //            model.tags?.sort(by: {$0.lowercased() == "pr" || ($0.lowercased() > $1.lowercased())})
            return model.tags?.contains(where: {$0.lowercased() == "pr"}) ?? false
        }
        prModels.sort(by: {
            let firstDate = DateFormatter.toDate(dateString: $0.releaseDate ?? "", format: "MM/dd/yyyy") ?? Date()
            let secondDate = DateFormatter.toDate(dateString: $1.releaseDate ?? "", format: "MM/dd/yyyy") ?? Date()
            return firstDate > secondDate
        })
        var nonPrModels = models.filter { model in
            //            let tags = Array(model.tags)
            return !(model.tags?.contains(where: {$0.lowercased() == "pr"}) ?? false)
        }
        nonPrModels.sort(by: {
            let firstDate = DateFormatter.toDate(dateString: $0.releaseDate ?? "", format: "MM/dd/yyyy") ?? Date()
            let secondDate = DateFormatter.toDate(dateString: $1.releaseDate ?? "", format: "MM/dd/yyyy") ?? Date()
            return firstDate > secondDate
        })
        output?.obtained(models: convert(prModels + nonPrModels))
    }
    
    func getLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
    func sendData(image: String?, title: String?, description: String?) {
        let notification = PushNotification()
        notification.image = image ?? ""
        notification.title = title ?? "N/A"
        notification.body = description ?? "N/A"
        GlobalConstants.Notification.getNotification.fire(withObject: notification)
    }
    
}
