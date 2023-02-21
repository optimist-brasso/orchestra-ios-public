//
//  PlayerInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//
//

import Foundation
import Alamofire

class PlayerInteractor {
    
    // MARK: Properties
    weak var output: PlayerInteractorOutput?
    private let service: PlayerServiceType
    var id: Int?
    
    // MARK: Initialization
    init(service: PlayerServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFavourite(_:)), name: GlobalConstants.Notification.didUpdateFavourite.notificationName, object: nil)
    }
    
    // MARK: Converting entities
    private func convert(_ model: Musician) -> PlayerStructure {
        let birthdayDate = DateFormatter.toDate(dateString: model.birthday ?? "", format: "yyyy/MM/dd", timeZone: .utc)
        let birthdayDateString = DateFormatter.toString(date: birthdayDate ?? Date(), format: "M/d")
        let birthDate = birthdayDateString.components(separatedBy: "/")
        let birthdayDateDisplayString = "\(birthDate.first ?? "")\(LocalizedKey.month.value)\(birthDate.last ?? "")\(LocalizedKey.date.value)"
        return PlayerStructure(id: model.id,
                               name: model.name,
                               images: model.images,
                               band: model.band,
                               birthday: model.birthday == nil ? nil : birthdayDateDisplayString,
                               bloodGroup: model.bloodGroup,
                               birthplace: model.birthplace,
                               message: model.message,
                               profileLink: model.profileLink,
                               twitter: model.twitter,
                               instagram: model.instagram,
                               facebook: model.facebook,
                               youtube: model.youtube,
                               performances: convert(model.performances ?? []),
                               isFavourite: model.isFavourite,
                               manufacturer: model.manufacturer,
                               instrument: model.instrument?.name,
                               instrumentId: model.instrument?.id)
    }
    
    private func convert(_ models: [Orchestra]) -> [PlayerPerformanceStructure] {
        return models.map({PlayerPerformanceStructure(id: $0.id,
                                                      title: $0.title,
                                                      titleJapanese: $0.titleJapanese,
                                                      image: $0.image,
                                                      duration: $0.duration?.time,
                                                      releaseDate: $0.releaseDate,
                                                      vrFile: $0.iOSVrFile)})
    }
    
    //MARK: Other functions
    @objc private func didAddToCart() {
        output?.obtained(cartCount: service.cartCount)
    }
    
    @objc private func didReadNotification() {
        output?.obtained(notificationCount: service.notificationCount)
    }
    
    @objc private func didUpdateFavouriteItem(_ notification: Notification) {
        if let object = notification.object as? FavoriteFrom, object == .playerDetail {
            return
        }
        getData()
    }
    
    @objc private func didUpdateFavourite(_ notification: Notification) {
        if let model = notification.object as? Favourite,
           model.type == OrchestraType.player.rawValue,
           model.musician?.id == id {
            output?.obtainedFavouriteStatus(model.musician?.isFavourite ?? false)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: Player interactor input interface
extension PlayerInteractor: PlayerInteractorInput {
    
    func isLogin() -> Bool {
        service.isLoggedIn
    }
    
    func getData() {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
        if let id = id {
            service.fetchPlayerDetail(of: id) { [weak self] result in
                switch result {
                case .success(let model):
                    if let structure = self?.convert(model) {
                        self?.output?.obtained(structure)
                    }
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        } else {
            output?.obtained(EK_GlobalConstants.Error.oops)
        }
    }
    
    func favourite() {
        if NetworkReachabilityManager()?.isReachable  ?? false {
            guard service.isLoggedIn else {
                output?.obtainedLoginNeed()
                return
            }
            service.favouritePlayer(of: id ?? .zero) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.output?.obtainedFavouriteStatus(model.musician?.isFavourite ?? false)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: GlobalConstants.Notification.didUpdateFavouriteItem.notificationName, object: FavoriteFrom.playerDetail)
                    }
                case .failure(_):
                    break
                }
            }
        } else {
            output?.obtained(GlobalConstants.Error.noInternet)
        }
    }
    
    func getLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
}
