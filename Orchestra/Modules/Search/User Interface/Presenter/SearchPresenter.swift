//
//  SearchPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//

import Foundation

class SearchPresenter {
    
	// MARK: Properties
    weak var view: SearchViewInterface?
    var interactor: SearchInteractorInput?
    var wireframe: SearchWireframeInput?
    private var openMode: OpenMode?
 
    // MARK: Converting entities
    private func convert(_ models: [SearchStructure]) -> [SearchViewModel] {
        return models.map({SearchViewModel(id: $0.id,
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
                                           instrument: $0.instrument)})
    }
    
}

 // MARK: Search module interface
extension SearchPresenter: SearchModuleInterface {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool, type: OrchestraType, keyword: String?) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData(isRefresh: isRefreshed, type: type, keyword: keyword)
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func cart() {
        openMode = .cart(tab: .point)
        interactor?.getLoginStatus()
    }
    
    func login(for mode: OpenMode?) {
        wireframe?.openLogin(for: mode)
    }
    
    func search(for keyword: String) {
        view?.showLoading()
        interactor?.search(for: keyword)
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
        openMode = .favourite(tab: .point,
                              type: type,
                              id: id,
                              instrumentId: instrumentId,
                              musicianId: musicianId)
        interactor?.getLoginStatus()
//        interactor?.favourite(of: id, type: type)
    }
    
    func favourite(of id: Int?, type: OrchestraType) {
        guard let id = id else { return }
        openMode = .favourite(tab: .point, type: type, id: id)
        interactor?.getLoginStatus()
//        interactor?.favourite(of: id, type: type)
    }
    
}

// MARK: Search interactor output interface
extension SearchPresenter: SearchInteractorOutput {
    func obtained(_ session: SearchStructure) {
        view?.show(SearchViewModel(id: session.id,
                                   image: session.image,
                                   title: session.title,
                                   titleJapanese: session.titleJapanese,
                                   isPremium: session.isPremium,
                                   duration: session.duration,
                                   isConductorFavourite: session.isConductorFavourite,
                                   isSessionFavourite: session.isSessionFavourite,
                                   isHallSoundFavourite: session.isHallSoundFavourite,
                                   musicianId: session.musicianId,
                                   playerName: session.playerName,
                                   instrumentId: session.instrumentId,
                                   instrument: session.instrument))
    }
    
    
    func obtained(_ models: [SearchStructure], isSession: Bool, reload: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.hideLoading()
            self?.view?.endRefreshing()
        }
        view?.show(convert(models), isSession: isSession, isReload: reload)
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
    
    func obtained(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.hideLoading()
        }
        view?.show(error)
    }
    
    func obtainedLoginNeed() {
        view?.showLoginNeed(for: nil)
    }
    
    func obtained(hasMoreData: Bool) {
        view?.show(hasMoreData: hasMoreData)
    }
    
    func obtainedHideLoading() {
        view?.hideLoading()
        view?.endRefreshing()
    }
    
}
