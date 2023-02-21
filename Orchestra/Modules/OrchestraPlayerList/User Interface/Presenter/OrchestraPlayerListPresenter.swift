//
//  OrchestraPlayerListPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/07/2022.
//
//

import Foundation

class OrchestraPlayerListPresenter {
    
	// MARK: Properties
    weak var view: OrchestraPlayerListViewInterface?
    var interactor: OrchestraPlayerListInteractorInput?
    var wireframe: OrchestraPlayerListWireframeInput?
    private var openMode: OpenMode?

    // MARK: Converting entities
    private func convert(_ models: [OrchestraPlayerListStructure]) -> [OrchestraPlayerListViewModel] {
        return models.map({OrchestraPlayerListViewModel(id: $0.id,
                                                        name: $0.name,
                                                        instrument: $0.instrument,
                                                        image: $0.image)})
    }
    
}

 // MARK: OrchestraPlayerList module interface
extension OrchestraPlayerListPresenter: OrchestraPlayerListModuleInterface {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData(isRefresh: isRefreshed)
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func details(of id: Int?) {
        wireframe?.openDetails(of: id)
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

// MARK: OrchestraPlayerList interactor output interface
extension OrchestraPlayerListPresenter: OrchestraPlayerListInteractorOutput {
    
    func obtained(_ models: [OrchestraPlayerListStructure]) {
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
