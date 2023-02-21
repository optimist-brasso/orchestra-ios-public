//
//  PlayerPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//
//

import Foundation

import Combine

class PlayerPresenter {
    
    // MARK: Properties
    weak var view: PlayerViewInterface?
    var interactor: PlayerInteractorInput?
    var wireframe: PlayerWireframeInput?
    var response = PassthroughSubject<(Bool, String), Never>()
    private var openMode: OpenMode?
    var id: Int?
    
    // MARK: Converting entities
    private func convert(_ model: PlayerStructure) -> PlayerViewModel {
        return PlayerViewModel(
            id: model.id,
            name: model.name,
            images: model.images,
            band: model.band,
            birthday: model.birthday,
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
            instrument: model.instrument,
            instrumentId: model.instrumentId)
    }
    
    private func convert(_ models: [PlayerPerformanceStructure]) -> [PlayerPerformanceViewModel] {
        return models.map({PlayerPerformanceViewModel(id: $0.id,
                                                      title: $0.title,
                                                      titleJapanese: $0.titleJapanese,
                                                      image: $0.image,
                                                      duration: $0.duration,
                                                      releaseDate: $0.releaseDate,
                                                      vrFile: $0.vrFile)})
    }
    
}

// MARK: Player module interface
extension PlayerPresenter: PlayerModuleInterface {
    
    func viewIsReady(withLoading: Bool) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData()
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func listing() {
        wireframe?.openListing()
    }
    
    func favourite() {
        guard let id = id else { return }
        let tabBar = wireframe?.view.tabBarController
        openMode = .favourite(tab: TabBarIndex(rawValue: tabBar?.selectedIndex ?? .zero) ?? .home,
                              type: .player,
                              id: id,
                              detailNavigation: true)
        interactor?.getLoginStatus()
    }
    
    func login(for mode: OpenMode?) {
        wireframe?.openLogin(for: mode)
    }
    
    func website(of url: String?) {
        wireframe?.openWebsite(of: url)
    }
    
    func cart() {
        let tabBar = wireframe?.view.tabBarController
        openMode = .cart(tab: TabBarIndex(rawValue: tabBar?.selectedIndex ?? .zero) ?? .home)
        interactor?.getLoginStatus()
    }
    
//    func sessionDetail(of id: Int?) {
//        if interactor?.isLogin() ?? false {
//            wireframe?.openSessionDetail(of: id)
//        } else {
//            view?.showLoginNeed(for: nil)
//        }
//    }
    
    func instrumentDetail(instrumentId: Int?, orchestraId: Int?, musicianId: Int?, isVRAvailable: Bool?) {
        guard let musicianId = musicianId else { return }
        let tabBar = wireframe?.view.tabBarController
        
        //isVRAvailable is false means no vrFile
        if !(isVRAvailable ?? false) {
            wireframe?.openConductorDetail(of: orchestraId)
            return
        }
        openMode = .instrumentDetail(tab: TabBarIndex(rawValue: tabBar?.selectedIndex ?? .zero) ?? .home,
                                     id: orchestraId,
                                     instrumentId: instrumentId,
                                     musicianId: musicianId)
        interactor?.getLoginStatus()
        //        if interactor?.isLogin() ?? false {
        //            wireframe?.openPartDetail(instrumentId: instrumentId, orchestraId: orchestraId, musicianId: musicianId)
        //        } else {
        //            view?.showLoginNeed(for: nil)
        //        }
    }
    
}

// MARK: Player interactor output interface
extension PlayerPresenter: PlayerInteractorOutput {
    
    func obtained(_ model: PlayerStructure) {
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(convert(model))
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
//        view?.alert(message: error.localizedDescription, title: "", okAction: { [weak self] in
//            self?.view?.endRefreshing()
//        })
    }
    
    func obtainedLoginNeed() {
        view?.showLoginNeed(for: nil)
    }
    
    func obtainedLoginStatus(_ status: Bool) {
        if status, let openMode = openMode {
            self.openMode = nil
            switch openMode {
            case .cart:
                wireframe?.openCart()
            case .favourite:
                interactor?.favourite()
            case .instrumentDetail(_, let id, let instrumentId, let musicianId):
                wireframe?.openIntrumentDetail(instrumentId: instrumentId, orchestraId: id, musicianId: musicianId, isMinusOne: false)
            default:
                break
            }
        } else {
            view?.showLoginNeed(for: openMode)
        }
    }
    
    func obtained(cartCount: Int) {
        view?.show(cartCount: cartCount)
    }
    
    func obtained(notificationCount: Int) {
        view?.show(notificationCount: notificationCount)
    }
    
    func obtainedFavouriteStatus(_ status: Bool) {
        view?.showFavouriteStatus(status)
    }
    
}
