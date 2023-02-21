//
//  PlaylistPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//

import Foundation

class PlaylistPresenter {
    
	// MARK: Properties
    weak var view: PlaylistViewInterface?
    var interactor: PlaylistInteractorInput?
    var wireframe: PlaylistWireframeInput?
    private var openMode: OpenMode?

    // MARK: Converting entities
    private func convert(_ models: [PlaylistStructure]) -> [PlaylistViewModel] {
        return models.map({PlaylistViewModel(id: $0.id,
                                             image: $0.image,
                                             title: $0.title,
                                             titleJapanese: $0.titleJapanese,
                                             isPremium: $0.isPremium,
                                             duration: $0.duration,
                                             isConductorFavourite: $0.isConductorFavourite,
                                             isSessionFavourite: $0.isSessionFavourite,
                                             isHallSoundFavourite: $0.isHallSoundFavourite,
                                             musicianId: $0.musicianId,
                                             playerName: $0.playerName,
                                             instrumentId: $0.instrumentId,
                                             instrument: $0.instrument,
                                             conductorImage: $0.conductorImage,
                                             venueDiagram: $0.venueDiagram)})
    }
    
}

 // MARK: Playlist module interface
extension PlaylistPresenter: PlaylistModuleInterface {
    
    func viewIsReady() {
        interactor?.getData()
    }
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool, type: OrchestraType) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData(isRefresh: isRefreshed, type: type, keyword: type == .session ? (isRefreshed ? "" : nil) : nil)
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func cart() {
        openMode = .cart(tab: .playlist)
        interactor?.getLoginStatus()
    }
    
    func login(for mode: OpenMode?) {
        wireframe?.openLogin(for: mode)
    }
    
    func orchestraDetail(of id: Int?, type: OrchestraType) {
        wireframe?.openOrchestraDetail(of: id, type: type)
    }
    
    func instrumentDetail(of id: Int?, orchestraId: Int?, musicianId: Int?) {
        //        wireframe?.openInstrumentDetail(of: id, orchestraId: orchestraId, musicianId: musicianId)
        guard let orchestraId = orchestraId,
              let instrumentId = id,
              let musicianId = musicianId else { return }
        openMode = .favourite(tab: .playlist,
                              type: .session,
                              id: orchestraId,
                              instrumentId: instrumentId,
                              musicianId: musicianId,
                              detailNavigation: true)
        interactor?.getLoginStatus()
    }
    
    func favourite(of id: Int?, instrumentId: Int?, musicianId: Int?, type: OrchestraType) {
        guard let id = id else { return }
        openMode = .favourite(tab: .playlist,
                              type: type,
                              id: id,
                              instrumentId: instrumentId,
                              musicianId: musicianId)
        interactor?.getLoginStatus()
//        interactor?.favourite(of: id, type: type)
    }
    
    func search(for keyword: String, type: OrchestraType) {
        view?.showLoading()
        interactor?.search(for: keyword, type: type)
    }
    
}

// MARK: Playlist interactor output interface
extension PlaylistPresenter: PlaylistInteractorOutput {
    
    func obtained(_ models: [PlaylistStructure], isSession: Bool, reload: Bool) {
        view?.endRefreshing()
        view?.show(convert(models), isSession: isSession, reload: reload)
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtainedLoginStatus(_ status: Bool) {
        if status, let openMode = openMode {
            self.openMode = nil
            switch openMode {
            case .cart:
                wireframe?.openCart()
            case .favourite(_, let type, let id, let instrumentId, let musicianId, let detailNavigation):
                if detailNavigation {
                    wireframe?.openInstrumentDetail(of: instrumentId, orchestraId: id, musicianId: musicianId)
                    return
                }
                interactor?.favourite(of: id, type: type, instrumentId: instrumentId, musicianId: musicianId)
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
    
    func obtainedLoginNeed() {
        view?.showLoginNeed(for: nil)
    }
    
    func obtained(hasMoreData: Bool) {
        view?.show(hasMoreData: hasMoreData)
    }
    
}
