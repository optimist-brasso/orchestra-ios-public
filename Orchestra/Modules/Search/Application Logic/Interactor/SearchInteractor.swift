//
//  SearchInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//

import Foundation
import Alamofire

class SearchInteractor {
    
	//MARK: Properties
    weak var output: SearchInteractorOutput?
    private let service: SearchServiceType
    private var page: Int = 1
    private var hasMoreData: Bool = true
    private var isLoading: Bool = false
    private var models = [Session]()
    private var keyword: String?
    
    //MARK: Initialization
    init(service: SearchServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFavouriteItem), name: GlobalConstants.Notification.didUpdateFavouriteItem.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFavourite(_:)), name: GlobalConstants.Notification.didUpdateFavourite.notificationName, object: nil)
    }
    
    //MARK: Converting entities
    private func convert(_ models: [Orchestra]) -> [SearchStructure] {
        models.map({
            //            let tags = Array($0.tags) as? [String]
            return SearchStructure(id: $0.id,
                                   image: $0.image,
                                   title: $0.title,
                                   titleJapanese: $0.titleJapanese,
                                   isPremium: $0.tags?.contains(where: {$0.lowercased() == "premium"}),
                                   duration: $0.duration?.time,
                                   isConductorFavourite: $0.isConductorFavourite,
                                   isSessionFavourite: $0.isSessionFavourite,
                                   isHallSoundFavourite: $0.isHallSoundFavourite)})
    }
    
    private func convert(_ models: [Session]) -> [SearchStructure] {
        models.map({
            return SearchStructure(id: $0.orchestra?.id,
                                   image: $0.musician?.image,
                                   title: $0.orchestra?.title,
                                   titleJapanese: $0.orchestra?.titleJapanese,
                                   isConductorFavourite: false,
                                   isSessionFavourite: $0.instrument?.isFavourite ?? false,
                                   isHallSoundFavourite: false,
                                   musicianId: $0.musician?.id,
                                   playerName: $0.musician?.name,
                                   instrumentId: $0.instrument?.id,
                                   instrument: $0.instrument?.name)})
    }
    
    //MARK: Other functions
    @objc private func didAddToCart() {
        output?.obtained(cartCount: service.cartCount)
    }
    
    @objc private func didReadNotification() {
        output?.obtained(notificationCount: service.notificationCount)
    }
    
    @objc private func didUpdateFavouriteItem() {
        search(for: "")
    }
    
    @objc private func didUpdateFavourite(_ notification: Notification) {
        if let modelFav = notification.object as? SessionFavoriteFrom {
            let model = modelFav.session
            if let index = models.firstIndex(where: { $0.orchestra?.id == model.orchestra?.id && $0.instrument?.id == model.instrument?.id && $0.musician?.id == model.musician?.id }) {
                models[index].instrument?.isFavourite =  model.instrument?.isFavourite ?? false
//
//                 let selected = models[index]
//                 let structure = SearchStructure(id: selected.orchestra?.id,
//                                                image: selected.player?.image,
//                                                title: selected.orchestra?.title,
//                                                titleJapanese: selected.orchestra?.titleJapanese,
//                                                isConductorFavourite: false,
//                                                isSessionFavourite: selected.instrument?.isFavourite ?? false,
//                                                isHallSoundFavourite: false,
//                                                musicianId: selected.player?.id,
//                                                playerName: selected.player?.name,
//                                                instrumentId: selected.instrument?.id,
//                                                instrument: selected.instrument?.name)
//
//                output?.obtained(structure)
                output?.obtained(convert(models), isSession: true, reload:  modelFav.type != .search)
    
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: Search interactor input interface
extension SearchInteractor: SearchInteractorInput {
    
    func getData(isRefresh: Bool, type: OrchestraType, keyword: String?) {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
        func fetchData() {
            switch type {
            case .conductor,
                    .hallSound:
                search(for: "")
            case .session:
                if let keyword = keyword {
                    if !keyword.isEmpty && self.keyword == keyword {
//                        output?.obtainedHideLoading()
                        return
                    }
                    self.keyword = keyword
                }
                isLoading = true
                service.fetchSessionList(of: page, keyword: self.keyword) { [weak self] result in
                    switch result {
                    case .success((let models, let totalPages)):
                        self?.isLoading = false
                        self?.page += 1
                        self?.hasMoreData = (self?.page ?? .zero) <= totalPages
                        self?.models.append(contentsOf: models)
                        self?.output?.obtained(self?.convert(self?.models ?? []) ?? [], isSession: true, reload: true)
                        self?.output?.obtained(hasMoreData: self?.hasMoreData ?? false)
                    case .failure(let error):
                        self?.isLoading = false
                        self?.output?.obtained(error)
                    }
                }
            case .player:
                break
            }
        }
        
        if isRefresh {
            isLoading = false
            if type == .session {
                hasMoreData = true
                page = 1
                models.removeAll()
            }
        }
        if type != .session {
            service.getNotificationList { [weak self] _ in
                self?.output?.obtained(notificationCount: self?.service.notificationCount ?? .zero)
                fetchData()
            }
        } else if !isLoading && hasMoreData {
            print("Page: \(page)")
            if page == 1 {
                service.getNotificationList { [weak self] _ in
                    self?.output?.obtained(notificationCount: self?.service.notificationCount ?? .zero)
                    fetchData()
                }
            } else {
                fetchData()
            }
        }
    }
    
    func getLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
    func search(for keyword: String) {
        service.search(for: keyword) { [weak self] result in
            switch result {
            case .success(let models):
                self?.output?.obtained(self?.convert(models) ?? [], isSession: false, reload: true)
            case .failure(let error):
                self?.output?.obtained(error)
            }
        }
    }
    
    func favourite(of id: Int?, type: OrchestraType, instrumentId: Int?, musicianId: Int?) {
        guard service.isLoggedIn else {
            output?.obtainedLoginNeed()
            return
        }
        switch type {
        case .conductor,
                .hallSound:
            if NetworkReachabilityManager()?.isReachable ?? false {
                service.favouriteOrchestra(of: id ?? .zero, for: type) {  result in
                    switch result {
                    case .success(_):
                        NotificationCenter.default.post(name: GlobalConstants.Notification.didUpdateFavouriteItem.notificationName, object: nil)
                    case .failure(_):
                        break
                    }
                }
            }else {
                output?.obtained(GlobalConstants.Error.noInternet)
            }
        case .session:
            if NetworkReachabilityManager()?.isReachable ?? false {
                guard let id = id, let instrumentId = instrumentId, let musicianId = musicianId else { return }
                service.favourite(of: id, instrumentId: instrumentId, musicianId: musicianId, from: .search) { result in
                    switch result {
                    case .success(let model):
                        break
                    case .failure(_):
                        break
                    }
                }
            }else {
                output?.obtained(GlobalConstants.Error.noInternet)
            }
        default: break
        }
    }
    
}
