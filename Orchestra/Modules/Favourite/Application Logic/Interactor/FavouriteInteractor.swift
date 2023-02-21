//
//  FavouriteInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/04/2022.
//
//

import Foundation
import CloudKit
import Alamofire

class FavouriteInteractor {
    
	// MARK: Properties
    weak var output: FavouriteInteractorOutput?
    private let service: FavouriteServiceType
    private var page: Int = 1
    private var hasMoreData: Bool = true
    private var isLoading: Bool = false
    private var models = [Session]()
    private var keyword: String?
    
    // MARK: Initialization
    init(service: FavouriteServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFavourite(_:)), name: GlobalConstants.Notification.didUpdateFavourite.notificationName, object: nil)
    }
    
    //MARK: Converting entities
    private func convert(_ models: [Session]) -> [FavouriteStructure] {
        models.map({
            return FavouriteStructure(id: $0.orchestra?.id,
                                      image: $0.musician?.image,
                                      title: $0.orchestra?.title,
                                      titleJapanese: $0.orchestra?.titleJapanese,
                                      isSessionFavourite: $0.instrument?.isFavourite ?? false,
                                      musicianId: $0.musician?.id,
                                      playerName: $0.musician?.name,
                                      instrumentId: $0.instrument?.id,
                                      instrument: $0.instrument?.name,
                                      conductorImage: $0.orchestra?.conductorImage,
                                      sessionImage: $0.orchestra?.sessionImage,
                                      venueDiagram: $0.orchestra?.venueDiagram)})
    }
    
    //MARK: Other functions
    @objc private func didAddToCart() {
        output?.obtained(cartCount: service.cartCount)
    }
    
    @objc private func didReadNotification() {
        output?.obtained(notificationCount: service.notificationCount)
    }
    
    @objc private func didUpdateFavourite(_ notification: Notification) {
        if let model = notification.object as? SessionFavoriteFrom, model.type != .favorite  {
            let model = model.session
            if let index = models.firstIndex(where: { $0.orchestra?.id == model.orchestra?.id && $0.instrument?.id == model.instrument?.id && $0.musician?.id == model.musician?.id }) {
                let removeModel = models[index]
                models.remove(at: index)
                let structure = FavouriteStructure(id: removeModel.orchestra?.id,
                                                                     image: removeModel.musician?.image,
                                                                     title: removeModel.orchestra?.title,
                                                                     titleJapanese: removeModel.orchestra?.titleJapanese,
                                                                     isSessionFavourite: removeModel.instrument?.isFavourite ?? false,
                                                                     musicianId: removeModel.musician?.id,
                                                                     playerName: removeModel.musician?.name,
                                                                     instrumentId: removeModel.instrument?.id,
                                                                     instrument: removeModel.instrument?.name,
                                                   conductorImage:  removeModel.orchestra?.conductorImage,
                                                   sessionImage:  removeModel.orchestra?.sessionImage,
                                                   venueDiagram:  removeModel.orchestra?.venueDiagram)
                output?.obtainedRemove(model: structure)
            } else {
                models.append(model)
                output?.obtained(convert(models), type: .session)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: Favourite interactor input interface
extension FavouriteInteractor: FavouriteInteractorInput {
    
    func getFavouritePlayerList(param: [String: Any], completion: @escaping (Result<([FavouritePlayer], Pagination?), Error>) -> Void) {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
        service.getFavouritePlayer(param: param, completion: completion)
    }
    
    func unfavoritePlayer(of id: Int, completion: @escaping (Result<Favourite, Error>) ->  Void) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            service.favouritePlayer(of: id, completion: completion)
        } else {
            output?.obtained(GlobalConstants.Error.noInternet)
        }
    }
    
    func unfavourite(_ model: Orchestra, for type: OrchestraType, completion: @escaping (Result<Favourite, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            service.favouriteOrchestra(model, for: type, completion: completion)
        } else {
            output?.obtained(GlobalConstants.Error.noInternet)
        }
    }
    
    func getFavouriteList(of type: FavouriteType, completion: @escaping (Result<[Favourite], Error>) -> Void) {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
        service.getNotificationList { [weak self] _ in
            self?.output?.obtained(notificationCount: self?.service.notificationCount ?? .zero)
            switch type {
            case .conductor,
                    .hallSound:
                 break
            case .session:
                break
//                self?.service.getSessionFavouriteList(completion: completion)
            case .player:
                break
            }
            self?.service.getFavouriteList(completion: completion)
        }
    }
    
    func search(for keyword: String, type: FavouriteType) {
        switch type {
        case .conductor, /*.session,*/
                .hallSound:
            service.search(for: keyword) { [weak self] result in
                switch result {
                case .success(let models):
                    self?.output?.obtained(models)
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        case .session:
            break
        case .player:
            service.searchPlayer(for: keyword) { [weak self] result in
                switch result {
                case .success(let models):
                    self?.output?.obtained(models)
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        }
   }
    
    func getData(isRefresh: Bool, type: OrchestraType, keyword: String?) {
       
       func fetchData() {
           switch type {
           case .conductor,
                   .hallSound:
               break
           case .session:
               if let keyword = keyword {
                   if !keyword.isEmpty && self.keyword == keyword {
                       return
                   }
                   self.keyword = keyword
               }
               isLoading = true
               service.fetchSessionFavouriteList(of: page, keyword: self.keyword) { [weak self] result in
                   switch result {
                   case .success((let models, let totalPages)):
                       self?.isLoading = false
                       self?.page += 1
                       self?.hasMoreData = (self?.page ?? .zero) <= totalPages
                       self?.models.append(contentsOf: models)
                       self?.output?.obtained(self?.convert(self?.models ?? []) ?? [], type: type)
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
           output?.obtained(cartCount: service.cartCount)
           output?.obtained(notificationCount: service.notificationCount)
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
    
    func unfavourite(of id: Int?, instrumentId: Int?, musicianId: Int?) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            guard let id = id, let instrumentId = instrumentId, let musicianId = musicianId else { return }
            service.favourite(of: id, instrumentId: instrumentId, musicianId: musicianId, from: .favorite) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    if let index = self.models.firstIndex(where: {$0.orchestra?.id == id && $0.instrument?.id == instrumentId && $0.musician?.id == musicianId}) {
                        let removeModel = self.models[index]
                        self.models.remove(at: index)
                        let structure = FavouriteStructure(id: removeModel.orchestra?.id,
                                                           image: removeModel.musician?.image,
                                                           title: removeModel.orchestra?.title,
                                                           titleJapanese: removeModel.orchestra?.titleJapanese,
                                                           isSessionFavourite: removeModel.instrument?.isFavourite ?? false,
                                                           musicianId: removeModel.musician?.id,
                                                           playerName: removeModel.musician?.name,
                                                           instrumentId: removeModel.instrument?.id,
                                                           instrument: removeModel.instrument?.name,
                                                           conductorImage: removeModel.orchestra?.conductorImage,
                                                           sessionImage: removeModel.orchestra?.sessionImage,
                                                           venueDiagram: removeModel.orchestra?.venueDiagram)
                        self.output?.obtainedRemove(model: structure)
                        // self?.output?.obtained(self?.convert(self?.models ?? []) ?? [], type: .session)
                    }
                case .failure(let error):
                    self.output?.obtained(error)
                }
            }
        } else {
            output?.obtained(GlobalConstants.Error.noInternet)
        }
    }
    
}
