//
//  OrchestraListingPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

import Foundation

class OrchestraListingPresenter {
    
	// MARK: Properties
    weak var view: OrchestraListingViewInterface?
    var interactor: OrchestraListingInteractorInput?
    var wireframe: OrchestraListingWireframeInput?
    private var openMode: OpenMode?

    // MARK: Converting entities
    private func convert(_ models: [OrchestraListingStructure]) -> [OrchestraListingViewModel] {
        return models.map({
            return OrchestraListingViewModel(id: $0.id,
                                             title: $0.title,
                                             titleJapanese: $0.titleJapanese,
                                             releaseDate: $0.releaseDate,
                                             duration: $0.duration,
                                             image: $0.image,
                                             conductorImage: $0.conductorImage,
                                             sessionImage: $0.sessionImage,venueDiagram: $0.venueDiagram)
        })
    }
    
}

 // MARK: OrchestraListing module interface
extension OrchestraListingPresenter: OrchestraListingModuleInterface {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData(isRefresh: isRefreshed)
    }
    
    func orchestraListing(of type: OrchestraType) {
        wireframe?.openOrchestraListing(of: type)
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func search(for keyword: String) {
        view?.showLoading()
        interactor?.search(for: keyword)
    }
    
    func orchestraDetail(of id: Int?) {
        wireframe?.openOrchestraDetail(of: id)
    }
    
    func cart() {
        let tabBar = wireframe?.view.tabBarController
        openMode = .cart(tab: TabBarIndex(rawValue: tabBar?.selectedIndex ?? .zero) ?? .home)
        interactor?.getLoginStatus()
    }
    
    func login(for mode: OpenMode?) {
        wireframe?.openLogin(for: mode)
    }
    
}

// MARK: OrchestraListing interactor output interface
extension OrchestraListingPresenter: OrchestraListingInteractorOutput {
    
    func obtained(point: PointHistory?) {
        view?.show(point: point)
    }
    
    func obtained(_ models: [OrchestraListingStructure]) {
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(convert(models))
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
