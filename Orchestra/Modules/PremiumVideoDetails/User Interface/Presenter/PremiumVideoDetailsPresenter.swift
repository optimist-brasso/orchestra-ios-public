//
//  PremiumVideoDetailsPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import Foundation

class PremiumVideoDetailsPresenter {
    
	// MARK: Properties
    weak var view: PremiumVideoDetailsViewInterface?
    var interactor: PremiumVideoDetailsInteractorInput?
    var wireframe: PremiumVideoDetailsWireframeInput?
    private var openMode: OpenMode?
    private var isDownloaded = false

    // MARK: Converting entities
    private func convert(_ model: PremiumVideoDetailsStructure) -> PremiumVideoDetailsViewModel {
        return PremiumVideoDetailsViewModel(instrument: model.instrument,
                                            musician: model.musician,
                                            file: model.file,
                                            thumbnail: model.thumbnail,
                                            description: model.description,
                                            orchestra: model.orchestra.flatMap(convert),
                                            isPartBought: model.isPartBought,
                                            isBought: model.isBought,
                                            price: model.price,
                                            isDownloaded: model.isDownloaded,
                                            isFavourite: model.isFavourite)
    }
    
    private func convert(_ model: PremiumVideoDetailsOrchestraStructure) -> PremiumVideoDetailsOrchestraViewModel {
        return PremiumVideoDetailsOrchestraViewModel(title: model.title,
                                                     titleJapanese: model.titleJapanese,
                                                     description: model.description,
                                                     composer: model.composer,
                                                     conductor: model.conductor,
                                                     venueTitle: model.venueTitle,
                                                     venueDescription: model.venueDescription,
                                                     duration: model.duration,
                                                     releaseDate: model.releaseDate,
                                                     image: model.image,
                                                     organization: model.organization,
                                                     businessType: model.businessType,
                                                     liscenceNumber: model.liscenceNumber,
                                                     organizationDiagram: model.organizationDiagram,
                                                     band: model.band)
    }
    
}

 // MARK: PremiumVideoDetails module interface
extension PremiumVideoDetailsPresenter: PremiumVideoDetailsModuleInterface {
    
    func viewIsReady(withLoading: Bool) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getFromApiData()
    }
    
    func cart() {
        openMode = .cart()
        interactor?.getLoginStatus()
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func previousModule() {
        wireframe?.openPreviousModule()
    }
    
    func login() {
        wireframe?.openLogin()
    }
    
    func addToCart(type: SessionType) {
        openMode = .addToCart(type: type)
        interactor?.getLoginStatus()
    }
    
    func imageViewer(with imageUrl: String?) {
        wireframe?.openImageViewer(with: imageUrl)
    }
        
    func bulkPurchase() {
        openMode = .bulkBuy
        interactor?.getLoginStatus()
    }
    
    func download() {
        interactor?.download(withWarning: true)
    }
    
    func cancelDownload() {
        interactor?.cancelDownload()
    }
    
    func favourite() {
        interactor?.favourite()
    }
    
    func vr() {
        if isDownloaded {
            wireframe?.openVR()
            interactor?.sendVRData()
        } else {
            interactor?.download(withWarning: true)
        }
    }
    
    func appendixVideo() {
        wireframe?.openAppendixVideo()
        interactor?.sendData()
    }
    
}

// MARK: PremiumVideoDetails interactor output interface
extension PremiumVideoDetailsPresenter: PremiumVideoDetailsInteractorOutput {
    
    func obtained(_ model: PremiumVideoDetailsStructure) {
        isDownloaded = model.isDownloaded ?? false
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(convert(model))
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(error)
    }
    
    func obtained(cartCount: Int) {
        view?.show(cartCount: cartCount)
    }
    
    func obtained(notificationCount: Int) {
        view?.show(notificationCount: notificationCount)
    }
    
    func obtainedLoginStatus(_ status: Bool) {
        if status, let openMode = openMode {
            self.openMode = nil
            switch openMode {
            case .cart:
                wireframe?.openCart()
            case .addToCart(let type):
                wireframe?.openBuy(for: type)
                interactor?.sendData()
            case .bulkBuy:
                wireframe?.openBulkPurchase()
                interactor?.sendData()
            default:
                break
            }
        } else {
            view?.showLoginNeed()
        }
    }
    
    func obtained(_ downloadState: DownloadConstants.DownloadState, progress: Float?) {
        view?.show(downloadState, progress: progress)
    }
    
    func obtainedDownloadWarningNeed() {
        view?.alertWithOkCancel(message: LocalizedKey.cellularDownloadWarning.value, title: nil, style: .alert, okTitle: LocalizedKey.ok.value, okStyle: .default, cancelTitle: LocalizedKey.cancel.value, cancelStyle: .cancel, okAction: { [weak self] in
            self?.interactor?.download(withWarning: false)
        }, cancelAction: nil)
    }
    
    func obtainedPlayState() {
        isDownloaded = true
        view?.showPlayState()
    }
    
    func obtainedLoadingNeed() {
        view?.showLoading()
    }
    
    func obtainedDownloadStart() {
        view?.showDownloadStart()
    }
    
}
