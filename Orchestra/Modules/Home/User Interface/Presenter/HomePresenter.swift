//
//  HomePresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//
//

import Foundation

class HomePresenter {
    
	// MARK: Properties
    weak var view: HomeViewInterface?
    var interactor: HomeInteractorInput?
    var wireframe: HomeWireframeInput?
    private var openMode: OpenMode?

    // MARK: Converting entities
    private func convert(_ models: [HomeBannerStructure]) -> [HomeBannerViewModel] {
        models.map({HomeBannerViewModel(image: $0.image,
                                        title: $0.title,
                                        description: $0.description,
                                        url: $0.url)})
    }
    
    private func convert(_ models: [HomeRecommendationStructure]) -> [HomeRecommendationViewModel] {
        models.map({HomeRecommendationViewModel(id: $0.id,
                                                title: $0.title,
                                                titleJapanese: $0.titleJapanese,
                                                image: $0.image,
                                                duration: $0.duration,
                                                releaseDate: $0.releaseDate,
                                                tags: $0.tags)})
    }
    
}

 // MARK: Home module interface
extension HomePresenter: HomeModuleInterface {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData(isRefresh: isRefreshed)
    }
    
    func homeListing(of type: OrchestraType) {
        wireframe?.openHomeListing(of: type)
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func bannerDetails(_ details: (url: String?, image: String?, title: String?, description: String?)) {
        wireframe?.openBannerDetails(for: details.url)
        interactor?.sendData(image: details.image, title: details.title, description: details.description)
    }
    
    func details(of id: Int?) {
        wireframe?.openDetails(of: id)
    }
    
    func cart() {
        openMode = .cart()
        interactor?.getLoginStatus()
    }
    
    func login(for mode: OpenMode?) {
        wireframe?.openLogin(for: mode)
    }
    
}

// MARK: Home interactor output interface
extension HomePresenter: HomeInteractorOutput {
    
    func obtained(point: PointHistory?) {
        view?.show(point: point)
    }
    
    func obtained(models: [HomeRecommendationStructure]) {
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(convert(models))
    }
    
    func obtained(models: [HomeBannerStructure]) {
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
