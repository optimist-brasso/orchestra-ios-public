//
//  ConductorDetailPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//
//

import Foundation
import Combine

class ConductorDetailPresenter {
    
	// MARK: Properties
    weak var view: ConductorDetailViewInterface?
    var interactor: ConductorDetailInteractorInput?
    var wireframe: ConductorDetailWireframeInput?
    var response = PassthroughSubject<(Bool, String), Never>()
    private var openMode: OpenMode?
    var id: Int?
    private var isDownloaded = false

    // MARK: Converting entities
    private func convert(_ model: ConductorDetailStructure) -> ConductorDetailViewModel {
        return ConductorDetailViewModel(title: model.title,
                                        image: model.image,
                                        description: model.description,
                                        composer: model.composer,
                                        conductor: model.conductor,
                                        venue: model.venue,
                                        duration: model.duration,
                                        releaseDate: model.releaseDate,
                                        organization: model.organization,
                                        businessType: model.businessType,
                                        band: model.band,
                                        liscenceNumber: model.liscenceNumber,
                                        organizationDiagram: model.organizationDiagram,
                                        isFavourite: model.isFavourite,
                                        vrFile: model.vrFile,
                                        vrThumbnail: model.vrThumbnail,
                                        isDownloaded: model.isDownloaded)
    }
    
}

 // MARK: ConductorDetail module interface
extension ConductorDetailPresenter: ConductorDetailModuleInterface {
    
    func viewIsReady(withLoading: Bool) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData()
    }
    
    func cart() {
        let tabBar = wireframe?.view.tabBarController
        openMode = .cart(tab: TabBarIndex(rawValue: tabBar?.selectedIndex ?? .zero) ?? .home)
        interactor?.getLoginStatus()
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func listing() {
        wireframe?.openListing()
    }
    
    func imageViewer(with imageUrl: String?) {
        wireframe?.openImageViewer(with: imageUrl)
    }
    
    func orchestraDetails(as type: OrchestraType) {
        wireframe?.openOrchestraDetails(as: type)
    }
    
    func favourite() {
        guard let id = id else { return }
        let tabBar = wireframe?.view.tabBarController
        openMode = .favourite(tab: TabBarIndex(rawValue: tabBar?.selectedIndex ?? .zero) ?? .home,
                              type: .conductor,
                              id: id,
                              detailNavigation: true)
        interactor?.getLoginStatus()
//        interactor?.favourite()
    }
    
    func login(for mode: OpenMode?) {
        wireframe?.openLogin(for: mode)
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
    
}

// MARK: ConductorDetail interactor output interface
extension ConductorDetailPresenter: ConductorDetailInteractorOutput {
    
    func obtained(_ model: ConductorDetailStructure) {
        isDownloaded = model.isDownloaded
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(convert(model))
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtainedLoginNeed() {
        view?.showLoginNeed(for: nil)
    }
    
    func obtainedLoginStatus(_ status: Bool) {
        if status, let openMode = openMode {
            self.openMode = nil
            switch openMode {
            case .cart:
                wireframe?.openCart()
            case .favourite:
                interactor?.favourite()
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
    }
    
    func obtainedDownloadStart() {
        view?.showDownloadStart()
    }
    
    func obtainedFavouriteStatus(_ status: Bool) {
        view?.showFavouriteStatus(status)
    }
    
}
