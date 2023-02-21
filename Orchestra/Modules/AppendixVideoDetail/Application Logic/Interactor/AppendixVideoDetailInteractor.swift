//
//  AppendixVideoDetailInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//
//

import Foundation
import Alamofire



class AppendixVideoDetailInteractor {
    
    // MARK: Properties
    weak var output: AppendixVideoDetailInteractorOutput?
    private let service: AppendixVideoDetailServiceType
    private var model: Instrument?
//    private var canPlay = false
    
    var instrumentId: Int?
    var orchestraId: Int?
    var musicianId: Int?
    
    // MARK: Initialization
    init(service: AppendixVideoDetailServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetInstrument(_:)), name: GlobalConstants.Notification.getInstrument.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didObtainDownloadStatus(notification:)), name: DownloadConstants.Notification.videoDownloadStatus.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBuy(_:)), name: GlobalConstants.Notification.didBuy.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFavourite(_:)), name: GlobalConstants.Notification.didUpdateFavourite.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didClearDownload), name: GlobalConstants.Notification.didClearDownload.notificationName, object: nil)
    }
    
    // MARK: Converting entities
    private func convert(_ model: Instrument) -> AppendixVideoDetailStructure {
        return AppendixVideoDetailStructure(file: model.appendixFile,
                                            thumbnail: model.appendixThumbnail,
                                            isPartBought: model.isPartBought,
                                            isBought: model.isPremiumBought,
                                            instrument: model.name,
                                            price: "\(model.premiumPrice?.currencyMode ?? "0") \(LocalizedKey.points.value)",
                                            isDownloaded: !(service.fetchVrPath(of: model.appendixFile?.fileName)?.isEmpty ?? true) || model.appendixFile?.isEmpty ?? true,
                                            orchestra: model.orchestra.flatMap(convert),
                                            description: model.premiumDescription,
                                            isFavourite: model.isFavourite)
    }
    
    private func convert(_ model: Orchestra) -> AppendixVideoDetailOrchestraStructure {
        return AppendixVideoDetailOrchestraStructure(title: model.title,
                                                     titleJapanese: model.titleJapanese,
                                                     description: model.description,
                                                     image: model.image,
                                                     organizationDiagram: model.organizationDiagram,
                                                     composer: model.composer,
                                                     conductor: model.conductor,
                                                     venueTitle: model.venueTitle,
                                                     duration: model.duration?.time,
                                                     releaseDate: model.releaseDate,
                                                     organization: model.organization,
                                                     businessType: model.businessType,
                                                     liscenceNumber: model.liscenceNumber)
    }
    
    //MARK: Other functions
    @objc private func didAddToCart() {
        output?.obtained(cartCount: service.cartCount)
    }
    
    @objc private func didReadNotification() {
        output?.obtained(notificationCount: service.notificationCount)
    }
    
    @objc private func didGetInstrument(_ notification: Notification) {
        if let model = notification.object as? Instrument {
            self.model = model
        }
    }
    
    @objc private func didObtainDownloadStatus(notification: Notification) {
        if let downloadModel = notification.object as? DownloadedMedia,
           downloadModel.fileName == model?.appendixFile?.fileName {
            switch downloadModel.state {
            case .downloaded:
                model?.appendixVRPath = downloadModel.path
                output?.obtainedPlayState()
//                if canPlay {
//                    output?.obtainedAndPlay()
//                }
                if let model = model {
                    output?.obtained(convert(model))
                }
                output?.obtained(.downloaded, progress: nil)
            case .downloading:
                output?.obtained(.downloading, progress: downloadModel.progress)
            case .notDownloaded :
                output?.obtained(.notDownloaded, progress: nil)
            }
        } else if notification.object is NSError {
            output?.obtained(NSError(domain: "space-error", code: 28, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.diskFull.value]))
        }
    }
    
    @objc private func didBuy(_ notification: Notification) {
        if let model = model, let purchasedItems = notification.object as? [CartItem],
           let musicianId = model.musician?.id,
           let orchestraId = model.orchestra?.id,
           let index = purchasedItems.firstIndex(where: {musicianId == $0.musicianId &&
               orchestraId == $0.orchestraId &&
               ($0.sessionType == SessionType.premium.rawValue || $0.sessionType == SessionType.combo.rawValue) &&
               $0.orchestraType == OrchestraType.session.rawValue}),
           let purchasedItem = purchasedItems.element(at: index) {
            if purchasedItem.sessionType == SessionType.premium.rawValue {
                model.isPremiumBought = true
            } else if purchasedItem.sessionType == SessionType.combo.rawValue {
                model.isPartBought = true
                model.isPremiumBought = true
            }
            output?.obtained(convert(model))
        }
    }
    
    @objc private func didUpdateFavourite(_ notification: Notification) {
        if let session = notification.object as? SessionFavoriteFrom,
           session.session.instrument?.id == model?.id,
           session.session.orchestra?.id == model?.orchestra?.id,
           session.session.musician?.id == model?.musician?.id {
            self.model?.isFavourite = session.session.instrument?.isFavourite ?? false
            if let instrumentModel = self.model {
                output?.obtained(convert(instrumentModel))
            }
        }
    }
    
    @objc private func didClearDownload() {
        model?.appendixVRPath = nil
        if let model = model {
            output?.obtained(convert(model))
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: AppendixVideoDetail interactor input interface
extension AppendixVideoDetailInteractor: AppendixVideoDetailInteractorInput {
    
    func getFromApiData() {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
        if let id = instrumentId, let orchestraId = orchestraId, let musicianId = musicianId {
            service.fetchInstrumentDetail(of: id, in: orchestraId, musicianId: musicianId) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.model = model
                    if let structure = self?.convert(model) {
                        self?.output?.obtained(structure)
                        DispatchQueue.main.async { [weak self] in
                            self?.setDownloadState()
                        }
                    }
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        } else {
            output?.obtained(EK_GlobalConstants.Error.oops)
        }
    }
    
    func getData() {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
        if let model = model {
            output?.obtained(convert(model))
        }
    }
    
    func getLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
    func sendData() {
        if let model = model {
            //            model.isPartBought = true
            model.orchestra?.vrFile = model.appendixFile
            model.orchestra?.vrPath = model.appendixVRPath
            model.orchestra?.instrumentName = model.name
            let isBought = model.isPartBought && model.isPremiumBought
            model.orchestra?.playDuration = isBought ? nil : GlobalConstants.sampleDuration
            GlobalConstants.Notification.getInstrument.fire(withObject: model)
            //            GlobalConstants.Notification.getSessionLayout.fire(withObject: models)
        }
    }
    
    private func setDownloadState() {
        if let downloadModel = model?.fetchDownloadedMedia(of: .appendix) {
            if downloadModel.path?.isEmpty ?? true {
                if let downloadingModel = DownloadManager.shared.persistedVideos.first(where: {$0.key.fileName == downloadModel.fileName})?.value,
                   downloadingModel.state == .downloading {
                    output?.obtained(.downloading, progress: downloadingModel.progress)
                    return
                }
//                if let downloadingModel = DownloadManager.shared.persistedVideos[downloadModel.url ?? ""],
//                   downloadingModel.state == .downloading {
//                    output?.obtained(.downloading, progress: downloadingModel.progress)
//                    return
//                }
                output?.obtained(.notDownloaded, progress: nil)
            } else {
                model?.appendixVRPath = downloadModel.path?.currentLocalPath
                output?.obtained(.downloaded, progress: nil)
            }
        }
    }
    
    func download(withWarning: Bool) {
        if URL(string: model?.appendixFile ?? "") != nil,
           let downloadModel = model?.fetchDownloadedMedia(of: .appendix) {
            func download() {
                if NetworkReachabilityManager()?.isReachable == true {
                    //                self.canPlay = canPlay
                    output?.obtainedDownloadStart()
                    DownloadManager.shared.download(downloadModel)
                } else {
                    output?.obtained(GlobalConstants.Error.noInternet)
                }
            }
            
            if !withWarning {
                download()
                return
            }
            if let model = Cacher().value(type: StreamingDownloadSetting.self, forKey: .streamingDownloadSettings) {
                if NetworkReachabilityManager()?.isReachable ?? false {
                    if let network = NetworkReachability.shared.networkType {
                        switch network {
                        case .unavailable:
                            output?.obtained(GlobalConstants.Error.noInternet)
                        case .wifi:
                            download()
                        case .cellular:
                            if model.wifiDownloadOnly ?? false {
                                output?.obtained(NSError(domain: "download-error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.wifiDownloadOnly.value]))
                            } else if model.mobileDataNotify ?? false {
                                output?.obtainedDownloadWarningNeed()
                            } else {
                                download()
                            }
                        }
                    }
                } else {
                    output?.obtained(GlobalConstants.Error.noInternet)
                }
            }
        }
    }
    
    func cancelDownload() {
        if let downloadModel = model?.fetchDownloadedMedia(of: .appendix) {
            DownloadManager.shared.cancelDownload(downloadModel)
        }
    }
    
    func favourite() {
        if NetworkReachabilityManager()?.isReachable ?? false {
            guard let id = model?.orchestra?.id,
                  let instrumentId = model?.id,
                  let musicianId = model?.musician?.id else {
                return
            }
            service.favourite(of: id, instrumentId: instrumentId, musicianId: musicianId, from: .appendix) { result in
                switch result {
                case .success(_):
                    break
                case .failure(_):
                    break
                }
            }
        }else {
            output?.obtained(GlobalConstants.Error.noInternet)
        }
       
    }
    
}
