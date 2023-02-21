//
//  PlaylistInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//

import Foundation
import Alamofire

class PlaylistInteractor {
    
	// MARK: Properties
    weak var output: PlaylistInteractorOutput?
    private let service: PlaylistServiceType
    private var page: Int = 1
    private var hasMoreData: Bool = true
    private var isLoading: Bool = false
    private var models = [Orchestra]()
    private var sessionPage: Int = 1
    private var sessionHasMoreData: Bool = true
    private var sessionModels = [Session]()
    private var keyword: String?
    
    // MARK: Initialization
    init(service: PlaylistServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFavouriteItem(_:)), name: GlobalConstants.Notification.didUpdateFavouriteItem.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFavourite(_:)), name: GlobalConstants.Notification.didUpdateFavourite.notificationName, object: nil)
    }
    
    //MARK: Converting entities
    private func convert(_ models: [Orchestra]) -> [PlaylistStructure] {
        models.map({
            //            let tags = Array($0.tags) as? [String]
            return PlaylistStructure(id: $0.id,
                                     image: $0.image,
                                     title: $0.title,
                                     titleJapanese: $0.titleJapanese,
                                     isPremium: $0.tags?.contains(where: {$0.lowercased() == "premium"}),
                                     duration: $0.duration?.time,
                                     isConductorFavourite: $0.isConductorFavourite,
                                     isSessionFavourite: $0.isSessionFavourite,
                                     isHallSoundFavourite: $0.isHallSoundFavourite,
                                     conductorImage: $0.conductorImage,
                                     venueDiagram: $0.venueDiagram)})
    }
    
    private func convert(_ models: [Session]) -> [PlaylistStructure] {
        models.map({
            return PlaylistStructure(id: $0.orchestra?.id,
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
    
    @objc private func didUpdateFavouriteItem(_ notification: Notification) {
        if let fav = notification.object as? OrchestraFavorite,
           let interactor =  fav.interactor as? PlaylistInteractor, interactor === self {
            return
        }
        service.fetchOrchestraList(of: 1) { [weak self] result in
            switch result {
            case .success((let models, _)):
                self?.output?.obtained(self?.convert(models) ?? [], isSession: false, reload: true)
            case .failure(let error):
                self?.output?.obtained(error)
            }
        }
    }
    
    @objc private func didUpdateFavourite(_ notification: Notification) {
        if let modelFav = notification.object as? SessionFavoriteFrom  {
            let model = modelFav.session
            if let index = sessionModels.firstIndex(where: { $0.orchestra?.id == model.orchestra?.id && $0.instrument?.id == model.instrument?.id && $0.musician?.id == model.musician?.id }) {
                sessionModels[index].instrument?.isFavourite =  model.instrument?.isFavourite ?? false
                output?.obtained(convert(sessionModels), isSession: true, reload: modelFav.type != .playlist)
                
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: Playlist interactor input interface
extension PlaylistInteractor: PlaylistInteractorInput {
    
    func getData() {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
    }
    
    func getData(isRefresh: Bool, type: OrchestraType, keyword: String?) {
        func fetchData() {
            switch type {
            case .conductor,
                    .hallSound:
                service.fetchOrchestraList(of: page) { [weak self] result in
                    switch result {
                    case .success((let models, let totalPages)):
                        self?.isLoading = false
                        self?.page += 1
                        self?.hasMoreData = (self?.page ?? .zero) <= totalPages
                        self?.models.append(contentsOf: models)
                        self?.output?.obtained(self?.convert(self?.models ?? []) ?? [], isSession: false, reload: true)
                    case .failure(let error):
                        self?.output?.obtained(error)
                    }
                }
            case .session:
                if let keyword = keyword {
                    if !keyword.isEmpty && self.keyword == keyword {
                        return
                    }
                    self.keyword = keyword
                }
                service.fetchSessionList(of: sessionPage, keyword: self.keyword) { [weak self] result in
                    switch result {
                    case .success((let models, let totalPages)):
                        self?.isLoading = false
                        self?.sessionPage += 1
                        self?.sessionHasMoreData = (self?.sessionPage ?? .zero) <= totalPages
                        self?.sessionModels.append(contentsOf: models)
                        self?.output?.obtained(self?.convert(self?.sessionModels ?? []) ?? [], isSession: true, reload: true)
                        self?.output?.obtained(hasMoreData: self?.sessionHasMoreData ?? false)
                    case .failure(let error):
                        self?.output?.obtained(error)
                    }
                }
            case .player:
                break
            }
        }
        
        if isRefresh {
            output?.obtained(cartCount: service.cartCount)
            output?.obtained(notificationCount: service.notificationCount)
            isLoading = false
            if type == .session {
                sessionHasMoreData = true
                sessionPage = 1
                sessionModels.removeAll()
            } else {
                hasMoreData = true
                page = 1
                models.removeAll()
            }
        }
        if !isLoading && (hasMoreData || sessionHasMoreData) {
            isLoading = true
            if page == 1 || sessionPage == 1 {
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
    
    func favourite(of id: Int?, type: OrchestraType, instrumentId: Int?, musicianId: Int?) {
        guard service.isLoggedIn else {
            output?.obtainedLoginNeed()
            return
        }
        switch type {
        case .conductor,
                .hallSound:
            if NetworkReachabilityManager()?.isReachable ?? false {
                service.favouriteOrchestra(of: id ?? .zero, for: type) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(_):
                        let orchestraFavorite = OrchestraFavorite(id: id ?? .zero, type: type, interactor: self)
                        NotificationCenter.default.post(name: GlobalConstants.Notification.didUpdateFavouriteItem.notificationName, object: orchestraFavorite)
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
                service.favourite(of: id, instrumentId: instrumentId, musicianId: musicianId, from: .playlist) { result in
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
    
    func search(for keyword: String, type: OrchestraType) {
        switch type {
        case .conductor,
                .hallSound:
            service.search(for: keyword) { [weak self] result in
                switch result {
                case .success(let models):
                    self?.output?.obtained(self?.convert(models) ?? [], isSession: false, reload: true)
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        case .session:
            getData(isRefresh: true, type: type, keyword: keyword)
        default: break
        }
    }
    
}
