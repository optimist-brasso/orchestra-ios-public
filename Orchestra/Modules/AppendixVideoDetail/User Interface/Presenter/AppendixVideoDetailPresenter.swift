//
//  AppendixVideoDetailPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//
//

import Foundation

class AppendixVideoDetailPresenter {
    
	// MARK: Properties
    weak var view: AppendixVideoDetailViewInterface?
    var interactor: AppendixVideoDetailInteractorInput?
    var wireframe: AppendixVideoDetailWireframeInput?
    private var openMode: OpenMode?
    private var isDownloaded = false

    // MARK: Converting entities
    private func convert(_ model: AppendixVideoDetailStructure) -> AppendixVideoDetailViewModel {
        return AppendixVideoDetailViewModel(file: model.file,
                                            thumbnail: model.thumbnail,
                                            isPartBought: model.isPartBought,
                                            isBought: model.isBought,
                                            instrument: model.instrument,
                                            price: model.price,
                                            isDownloaded: model.isDownloaded,
                                            orchestra: model.orchestra.flatMap(convert),
                                            description: model.description,
                                            isFavourite: model.isFavourite)
    }
    
    private func convert(_ model: AppendixVideoDetailOrchestraStructure) -> AppendixVideoDetailOrchestraViewModel {
        return AppendixVideoDetailOrchestraViewModel(title: model.title,
                                                     titleJapanese: model.titleJapanese,
                                                     description: model.description,
                                                     image: model.image,
                                                     organizationDiagram: model.organizationDiagram,
                                                     composer: model.composer,
                                                     conductor: model.conductor,
                                                     venueTitle: model.venueTitle,
                                                     duration: model.duration,
                                                     releaseDate: model.releaseDate,
                                                     organization: model.organization,
                                                     businessType: model.businessType,
                                                     liscenceNumber: model.liscenceNumber)
    }
    
}

 // MARK: AppendixVideoDetail module interface
extension AppendixVideoDetailPresenter: AppendixVideoDetailModuleInterface {
    
//    func getDataFromApi() {
//        view?.showLoading()
//        interactor?.getFromApiData()
//    }
    
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
    
    func imageViewer(with imageUrl: String?) {
        wireframe?.openImageViewer(with: imageUrl)
    }
    
    func videoPlayer() {
        if isDownloaded {
            wireframe?.openVideoPlayer()
            interactor?.sendData()
        } else {
            interactor?.download(withWarning: true)
        }
    }
    
    func download() {
        interactor?.download(withWarning: true)
    }
    
    func cancelDownload() {
        interactor?.cancelDownload()
    }
    
//    func vr() {
//        wireframe?.openVR()
//        interactor?.sendVRData()
//    }
    
    func addToCart(type: SessionType) {
        openMode = .addToCart(type: type)
        interactor?.getLoginStatus()
    }
    
    func favourite() {
        interactor?.favourite()
    }
    
}

// MARK: AppendixVideoDetail interactor output interface
extension AppendixVideoDetailPresenter: AppendixVideoDetailInteractorOutput {
    
    func obtained(_ model: AppendixVideoDetailStructure) {
        isDownloaded = model.isDownloaded ?? false
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(convert(model))
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
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
    
    func obtainedDownloadStart() {
        view?.showDownloadStart()
    }
    
}
