//
//  PlayerListingPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

import Foundation

class PlayerListingPresenter {
    
	// MARK: Properties
    weak var view: PlayerListingViewInterface?
    var interactor: PlayerListingInteractorInput?
    var wireframe: PlayerListingWireframeInput?
    private var openMode: OpenMode?

    // MARK: Converting entities
    private func convert(_ models: [PlayerListingStructure]) -> [PlayerListingViewModel] {
        return models.map({PlayerListingViewModel(id: $0.id,
                                                  name: $0.name,
                                                  instrument: $0.instrument,
                                                  image: $0.image)})
    }
    
}

 // MARK: PlayerListing module interface
extension PlayerListingPresenter: PlayerListingModuleInterface {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool, keyword: String?) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData(isRefresh: isRefreshed, keyword: keyword)
    }
    
    func homeListing(of type: OrchestraType) {
        wireframe?.openOrchestraListing(of: type)
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func details(of id: Int?) {
        wireframe?.openDetails(of: id)
    }
    
    func cart() {
        openMode = .cart(tab: .playlist)
        interactor?.getLoginStatus()
    }
    
    func login(for mode: OpenMode?) {
        wireframe?.openLogin(for: mode)
    }
    
}

// MARK: PlayerListing interactor output interface
extension PlayerListingPresenter: PlayerListingInteractorOutput {
    
    func obtained(point: PointHistory?) {
        view?.show(point: point)
    }
    
    func obtained(_ models: [PlayerListingStructure]) {
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(convert(models))
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtained(_ hasMoreData: Bool) {
        view?.show(hasMoreData)
    }
    
    func obtainedLoginStatus(_ status: Bool) {
        if status, let openMode = openMode {
            self.openMode = nil
            switch openMode {
            case .cart:
                wireframe?.openCart()
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
    
}
