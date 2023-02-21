//
//  SessionLayoutPresenter.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 5/4/22.
//
//

import Foundation
import CoreGraphics
import StoreKit

class SessionLayoutPresenter {
    
	// MARK: Properties
    weak var view: SessionLayoutViewInterface?
    var interactor: SessionLayoutInteractorInput?
    var wireframe: SessionLayoutWireframeInput?
    private var openMode: OpenMode?

    // MARK: Converting entities
    private func convert(_ model: SessionStructure) -> SessionViewModel {
        return SessionViewModel(image: model.image, layouts: convert(model.layouts ?? []))
    }
    
    private func convert(_ models: [SessionLayoutStructure]) -> [SessionLayoutViewModel] {
        return models.map({SessionLayoutViewModel(x: $0.x,
                                                  y: $0.y,
                                                  height: $0.height,
                                                  width: $0.width,
                                                  instrument: $0.instrument.flatMap(convert))})
    }
    
    private func convert(_ model: SessionLayoutInstrumentStructure) -> SessionLayoutInstrumentViewModel {
        return SessionLayoutInstrumentViewModel(id: model.id,
                                                name: model.name,
                                                musicianId: model.musicianId,
                                                player: model.player,
                                                playerImage: model.playerImage,
                                                description: model.description,
                                                isBought: model.isBought)
    }

}

 // MARK: SessionLayout module interface
extension SessionLayoutPresenter: SessionLayoutModuleInterface {
    
    func viewIsReady(with navigationBarHeight: CGFloat?) {
        view?.showLoading()
        interactor?.getData(with: navigationBarHeight)
    }
    
    func instrumentDetails(of id: Int?, musicianId: Int?) {
        //        openMode = .session(id: id, musicianId: musicianId)
        guard let orchestraId = wireframe?.id,
              let instrumentId = id,
              let musicianId = musicianId else { return }
        let tabBar = wireframe?.view.tabBarController
        openMode = .buy(tab: TabBarIndex(rawValue: tabBar?.selectedIndex ?? .zero) ?? .home,
                        type: .session,
                        id: orchestraId,
                        instrumentId: instrumentId,
                        musicianId: musicianId)
        interactor?.getLoginStatus()
    }
    
    func previousModule() {
        wireframe?.openPreviousModule()
    }
    
    func login(for mode: OpenMode?) {
        wireframe?.openLogin(for: mode)
    }
    
}

// MARK: SessionLayout interactor output interface
extension SessionLayoutPresenter: SessionLayoutInteractorOutput {
    
    func obtained(_ model: SessionStructure) {
        view?.hideLoading()
        view?.show(convert(model))
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtainedLoginStatus(_ status: Bool) {
        if status, let openMode = openMode {
            self.openMode = nil
            switch openMode {
            case .session(let id, let musicianId):
                wireframe?.openInstrumentDetails(of: id, musicianId: musicianId)
                interactor?.sendData()
            case .buy(_, let type, _, let instrumentId, let musicianId):
                switch type {
                case .session:
//                    guard let instrumentId = instrumentId, let musicianId = musicianId else { return }
                    wireframe?.openInstrumentDetails(of: instrumentId, musicianId: musicianId)
                    interactor?.sendData()
//                    view?.showLoading()
//                    interactor?.getInstrument(of: instrumentId, musicianId: musicianId)
                case .conductor,
                        .hallSound,
                        .player:
                    break
                }
            default:
                break
            }
        } else {
            view?.showLoginNeed(for: openMode)
        }
    }
    
    func obtainedInstrumentRedirection(id: Int, musicianId: Int) {
        view?.hideLoading()
        wireframe?.openInstrumentDetails(of: id, musicianId: musicianId)
        interactor?.sendData()
    }
    
    func obtainedMusicianRedirection(of id: Int) {
        view?.hideLoading()
        wireframe?.openMusicianDetail(of: id)
    }
    
}
