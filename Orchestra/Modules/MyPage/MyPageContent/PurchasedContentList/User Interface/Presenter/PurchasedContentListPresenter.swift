//
//  PurchasedContentListPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import Foundation

class PurchasedContentListPresenter {
    
	// MARK: Properties
    weak var view: PurchasedContentListViewInterface?
    var interactor: PurchasedContentListInteractorInput?
    var wireframe: PurchasedContentListWireframeInput?

    // MARK: Converting entities
    private func convert(_ models: [PurchasedContentListStructure]) -> [PurchasedContentListViewModel] {
        return models.map({PurchasedContentListViewModel(title: $0.title,
                                                         titleJapanese: $0.titleJapanese,
                                                         releaseDate: $0.releaseDate,
                                                         duration: $0.duration,
                                                         image: $0.image)})
    }
    
}

 // MARK: PurchasedContentList module interface
extension PurchasedContentListPresenter: PurchasedContentListModuleInterface {
    func openPartDetail(instrumentId: Int?, orchestraId: Int?, musicianId: Int?) {
        wireframe?.openPartDetail(instrumentId: instrumentId, orchestraId: orchestraId, musicianId: musicianId)
    }
    
    func openPremiumDetail(instrumentId: Int?, orchestraId: Int?, musicianId: Int?) {
        wireframe?.openPremiumDetail(instrumentId: instrumentId, orchestraId: orchestraId, musicianId: musicianId)
    }
    
    func openConductor(id: Int) {
        wireframe?.openConductor(id: id)
    }
    
    func openHallSound(id: Int) {
        wireframe?.openHallSound(id: id)
    }
    
    
    func viewIsReady(withLoading: Bool) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData()
    }
    
    func search(for keyword: String) {
        interactor?.search(for: keyword)
    }
    
}

// MARK: PurchasedContentList interactor output interface
extension PurchasedContentListPresenter: PurchasedContentListInteractorOutput {
    func obtained(_ models: [PurchasedModel]) {
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(models)
    }
    
    
    func obtained(_ models: [PurchasedContentListStructure]) {
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(convert(models))
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
}
