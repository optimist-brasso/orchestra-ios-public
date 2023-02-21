//
//  HallSoundDetailPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//
//

import Foundation

class HallSoundDetailPresenter {
    
	// MARK: Properties
    weak var view: HallSoundDetailViewInterface?
    var interactor: HallSoundDetailInteractorInput?
    var wireframe: HallSoundDetailWireframeInput?
    private var openMode: OpenMode?
    var id: Int?

    // MARK: Converting entities
    private func convert(_ model: HallSoundDetailStructure) -> HallSoundDetailViewModel {
        return HallSoundDetailViewModel(title: model.title,
                                        titleJapanese: model.titleJapanese,
                                        description: model.description,
                                        composer: model.composer,
                                        band: model.band,
                                        conductor: model.conductor,
                                        organization: model.organization,
                                        venue: model.venue,
                                        venueDescription: model.venueDescription,
                                        duration: model.duration,
                                        releaseDate: model.releaseDate,
                                        liscenceNumber: model.liscenceNumber,
                                        isFavourite: model.isFavourite,
                                        isBought: model.isBought,
                                        image: model.image,
                                        businessType: model.businessType,
                                        hallsounds: convert(model.hallsounds ?? []),
//                                        leftFloor: model.leftFloor.flatMap(convert),
//                                        rightFloor: model.rightFloor.flatMap(convert),
//                                        centerFloor: model.centerFloor.flatMap(convert),
//                                        backFloor: model.backFloor.flatMap(convert),
                                        isDownloaded: model.isDownloaded)
    }
    
    private func convert(_ models: [HallSoundDetailAudioStrcture]) -> [HallSoundDetailAudioViewModel] {
        return models.map({HallSoundDetailAudioViewModel(image: $0.image,
                                                         audioLink: $0.audioLink,
                                                         type: $0.type)})
    }
    
    private func convert(_ model: HallSoundDetailAudioStrcture) -> HallSoundDetailAudioViewModel {
        return HallSoundDetailAudioViewModel(image: model.image,
                                             audioLink: model.audioLink,
                                             type: model.type,
                                             position: model.position)
    }
    
}

 // MARK: HallSoundDetail module interface
extension HallSoundDetailPresenter: HallSoundDetailModuleInterface {
    
    func viewIsReady(withLoading: Bool) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData()
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func listing() {
        wireframe?.openListing()
    }
    
    func buy() {
        if let id = id {
            let tabBar = wireframe?.view.tabBarController
            openMode = .buy(tab: TabBarIndex(rawValue: tabBar?.selectedIndex ?? .zero) ?? .home,
                            type: .hallSound,
                            id: id)
            interactor?.checkLoginStatus()
        }
//        wireframe?.openBuy()
    }

    func favourite() {
        guard let id = id else { return }
        let tabBar = wireframe?.view.tabBarController
        openMode = .favourite(tab: TabBarIndex(rawValue: tabBar?.selectedIndex ?? .zero) ?? .home,
                              type: .hallSound,
                              id: id,
                              detailNavigation: true)
        interactor?.checkLoginStatus()
        //        interactor?.favourite()
    }
    
    func login(for mode: OpenMode?) {
        wireframe?.openLogin(for: mode)
    }
    
    func orchestraDetail(as type: OrchestraType) {
        wireframe?.openOrchestraDetail(as: type)
    }
    
    func cart() {
        let tabBar = wireframe?.view.tabBarController
        openMode = .cart(tab: TabBarIndex(rawValue: tabBar?.selectedIndex ?? .zero) ?? .home)
        interactor?.checkLoginStatus()
    }
    
    func obtained(cartCount: Int) {
        view?.show(cartCount: cartCount)
    }
    
    func obtained(notificationCount: Int) {
        view?.show(notificationCount: notificationCount)
    }
    
    func download() {
        interactor?.download(withWarning: true)
    }
    
    func cancelDownload() {
        interactor?.cancelDownload()
    }
    
    func download(of index: Int) {
        interactor?.download(withWarning: true, index: index)
    }
    
}

// MARK: HallSoundDetail interactor output interface
extension HallSoundDetailPresenter: HallSoundDetailInteractorOutput {
    
    func obtained(_ model: HallSoundDetailStructure) {
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(convert(model))
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtainedBuySuccess() {
        view?.showBuySuccess()
    }
    
    func obtainedLoginNeed() {
        view?.showLoginNeed(for: nil)
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
            case .favourite:
                interactor?.favourite()
            default:
                break
            }
        } else {
            view?.showLoginNeed(for: openMode)
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
    
//    func obtainedAlreadyDownloadingState() {
//        view?.showAlreadyDownloadingState()
//    }
    
    func obtained(_ error: String) {
        view?.show(error)
    }
    
    func obtainedPlayStatus(of index: Int) {
        view?.showPlayStatus(of: index)
    }
    
    func obtainedFavouriteStatus(_ status: Bool) {
        view?.showFavouriteStatus(status)
    }

    func obtainedDownloadStart() {
        view?.showDownloadStart()
    }
    
}
