//
//  InstrumentDetailPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 6/13/22.
//
//

import Foundation

class InstrumentDetailPresenter {
    
	// MARK: Properties
    weak var view: InstrumentDetailViewInterface?
    var interactor: InstrumentDetailInteractorInput?
    var wireframe: InstrumentDetailWireframeInput?
    private var openMode: OpenMode?
    var id: Int?
    var orchestraId: Int?
    var musicianId: Int?
    private var isDownloaded = false

    // MARK: Converting entities
    private func convert(_ model: InstrumentDetailStructure) -> InstrumentDetailViewModel {
        return InstrumentDetailViewModel(name: model.name,
                                         musician: model.musician,
                                         vrFile: model.vrFile,
                                         vrThumbnail: model.vrThumbnail,
                                         description: model.description,
                                         orchestra: model.orchestra.flatMap(convert),
                                         isBought: model.isBought,
                                         isPremiumBought: model.isPremiumBought,
                                         price: model.price,
                                         isDownloaded: model.isDownloaded,
                                         isFavourite: model.isFavourite)
    }
    
    private func convert(_ model: InstrumentDetailOrchestraStructure) -> InstrumentDetailOrchestraViewModel {
        return InstrumentDetailOrchestraViewModel(title: model.title,
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

 // MARK: InstrumentDetail module interface
extension InstrumentDetailPresenter: InstrumentDetailModuleInterface {

    func viewIsReady(withLoading: Bool) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData()
    }
    
    func appendixVideo() {
        wireframe?.openAppendixVideo()
        interactor?.sendData()
    }
    
    func previousModule() {
        wireframe?.openPreviousModule()
        interactor?.sendData()
    }
    
    func bulkPurchase() {
        openMode = .bulkBuy
        interactor?.checkLoginStatus()
    }
    
    func buy() {
        guard let orchestraId = orchestraId else { return }
        openMode = .buy(type: .session,
                        id: orchestraId,
                        instrumentId: id,
                        musicianId: musicianId)
        interactor?.checkLoginStatus()
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func cart() {
        openMode = .cart()
        interactor?.checkLoginStatus()
    }
    
    func premiumVideo() {
        wireframe?.openPremiumVideo()
        interactor?.sendData()
    }
    
    func login() {
        wireframe?.openLogin()
    }
    
    func orchestraDetails(as type: OrchestraType) {
        wireframe?.openOrchestraDetails(as: type)
    }
    
    func imageViewer(with imageUrl: String?) {
        wireframe?.openImageViewer(with: imageUrl)
    }
    
    func vr() {
        if isDownloaded {
            wireframe?.openVR()
            interactor?.sendVRData()
        } else {
            interactor?.downloadVideo(withWarning: true)
        }
    }
    
    func downloadVideo() {
        interactor?.downloadVideo(withWarning: true)
    }
    
    func cancelDownload() {
        interactor?.cancelDownload()
    }
    
    func favourite() {
        interactor?.favourite()
    }
    
}

// MARK: InstrumentDetail interactor output interface
extension InstrumentDetailPresenter: InstrumentDetailInteractorOutput {
    
    func obtained(_ model: InstrumentDetailStructure) {
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
    
    func obtainedCartOpenNeed() {
        wireframe?.openCart()
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
            case .buy:
                wireframe?.openBuy()
                interactor?.sendData()
            case .cart:
                wireframe?.openCart()
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
            self?.interactor?.downloadVideo(withWarning: false)
        }, cancelAction: nil)
    }
    
    func obtainedPlayState() {
        isDownloaded = true
        view?.showPlayState()
//        wireframe?.openVR()
//        interactor?.sendVRData()
    }
    
    func obtainedLoadingNeed() {
        view?.showLoading()
    }
    
    func obtainedDownloadStart() {
        view?.showDownloadStart()
    }
    
}
