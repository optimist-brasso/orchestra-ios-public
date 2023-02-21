//
//  PremiumVideoDetailsInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import Foundation
import Alamofire

class PremiumVideoDetailsInteractor {
    
    // MARK: Properties
    weak var output: PremiumVideoDetailsInteractorOutput?
    private let service: PremiumVideoDetailsServiceType
    private var model: Instrument?
    // var id: Int?
    var orchestraId: Int?
    var musicianId: Int?
    var instrumentId: Int?
//    private var canPlay = false
    private var models: [SessionLayout]?
    
    // MARK: Initialization
    init(service: PremiumVideoDetailsServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didGetInstrument(_:)), name: GlobalConstants.Notification.getInstrument.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBuy(_:)), name: GlobalConstants.Notification.didBuy.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didObtainDownloadStatus(notification:)), name: DownloadConstants.Notification.videoDownloadStatus.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetSessionLayout(_:)), name: GlobalConstants.Notification.getSessionLayout.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFavourite(_:)), name: GlobalConstants.Notification.didUpdateFavourite.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didClearDownload), name: GlobalConstants.Notification.didClearDownload.notificationName, object: nil)
    }
    
    // MARK: Converting entities
    private func convert(_ model: Instrument) -> PremiumVideoDetailsStructure {
        return PremiumVideoDetailsStructure(instrument: model.name,
                                            musician: model.musician?.name,
                                            file: model.premiumVrFile,
                                            thumbnail: model.premiumVrThumbnail,
                                            description: model.premiumContent,
                                            orchestra: model.orchestra.flatMap(convert),
                                            isPartBought: model.isPartBought,
                                            isBought: model.isPremiumBought,
                                            price: "\(GlobalConstants.currency)\(model.premiumPrice?.currencyMode ?? "0")",
                                            isDownloaded: !(service.fetchVrPath(of: model.premiumVrFile?.fileName)?.isEmpty ?? true) || model.premiumVrFile?.isEmpty ?? true,
                                            isFavourite: model.isFavourite)
    }
    
    private func convert(_ model: Orchestra) -> PremiumVideoDetailsOrchestraStructure {
        return PremiumVideoDetailsOrchestraStructure(title: model.title,
                                                     titleJapanese: model.titleJapanese,
                                                     description: model.description,
                                                     composer: model.composer,
                                                     conductor: model.conductor,
                                                     venueTitle: model.venueTitle,
                                                     venueDescription: model.venueDescription,
                                                     duration: model.duration?.time,
                                                     releaseDate: model.releaseDate,
                                                     image: model.image,
                                                     organization: model.organization,
                                                     businessType: model.businessType,
                                                     liscenceNumber: model.liscenceNumber,
                                                     organizationDiagram: model.organizationDiagram,
                                                     band: model.band)
    }
    
    //MARK: Other functions
    @objc private func didAddToCart() {
        output?.obtained(cartCount: service.cartCount)
    }
    
    @objc private func didReadNotification() {
        output?.obtained(notificationCount: service.notificationCount)
    }
    
//    @objc private func didGetInstrument(_ notification: Notification) {
//        if let model = notification.object as? Instrument {
//            self.model = model
//        }
//    }
    
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
            output?.obtainedLoadingNeed()
            getFromApiData()
        }
    }
    
    @objc private func didObtainDownloadStatus(notification: Notification) {
        if let downloadModel = notification.object as? DownloadedMedia,
           downloadModel.fileName == model?.premiumVrFile?.fileName {
            switch downloadModel.state {
            case .downloaded:
                model?.premiumVRPath = downloadModel.path
                output?.obtainedPlayState()
                if let model = model {
                    output?.obtained(convert(model))
                }
                output?.obtained(.downloaded, progress: nil)
//                if canPlay {
//                    output?.obtainedPlayState()
//                }
            case .downloading:
                output?.obtained(.downloading, progress: downloadModel.progress)
            case .notDownloaded :
                output?.obtained(.notDownloaded, progress: nil)
                break
            }
        } else if notification.object is NSError {
            output?.obtained(NSError(domain: "space-error", code: 28, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.diskFull.value]))
        }
    }
    
    @objc private func didGetSessionLayout(_ notification: Notification) {
        if models == nil, let models = notification.object as? [SessionLayout] {
            self.models = models
        }
    }
    
    @objc private func didUpdateFavourite(_ notification: Notification) {
        if let session = notification.object as? SessionFavoriteFrom,
           self.model?.id == session.session.instrument?.id,
           self.model?.orchestra?.id == session.session.orchestra?.id,
           self.model?.musician?.id == session.session.musician?.id {
            self.model?.isFavourite = session.session.instrument?.isFavourite ?? false
            if let instrumentModel = self.model {
                output?.obtained(convert(instrumentModel))
            }
        }
    }
    
    @objc private func didClearDownload() {
        model?.premiumVRPath = nil
        if let model = model {
            output?.obtained(convert(model))
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: PremiumVideoDetails interactor input interface
extension PremiumVideoDetailsInteractor: PremiumVideoDetailsInteractorInput {
    
    func getData() {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
        getFromApiData()
//        if let model = model {
//            setDownloadState()
//            output?.obtained(convert(model))
//        }
    }
    
    func getLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
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
    
    func sendData() {
        if let model = model {
            GlobalConstants.Notification.getInstrument.fire(withObject: model)
            GlobalConstants.Notification.getSessionLayout.fire(withObject: models)
        }
    }
    
    private func setDownloadState() {
        if let downloadModel = model?.fetchDownloadedMedia(of: .premium) {
            if !(downloadModel.path?.isEmpty ?? true) {
                model?.premiumVRPath = downloadModel.path?.currentLocalPath
                output?.obtained(.downloaded, progress: nil)
            } else if downloadModel.path?.isEmpty ?? true {
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
            }
        }
    }
    
    func download(withWarning: Bool) {
        if URL(string: model?.premiumVrFile ?? "") != nil,
           let downloadModel = model?.fetchDownloadedMedia(of: .premium) {
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
        if let downloadModel = model?.fetchDownloadedMedia(of: .premium) {
            DownloadManager.shared.cancelDownload(downloadModel)
        }
    }
    
    func favourite() {
        if NetworkReachabilityManager()?.isReachable ?? false {
            guard let id = orchestraId,
                  let instrumentId = model?.id,
                  let musicianId = model?.musician?.id else {
                return
            }
            service.favourite(of: id, instrumentId: instrumentId, musicianId: musicianId, from: .premium) { _ in }
        } else {
            output?.obtained(GlobalConstants.Error.noInternet)
        }
    }
    
    func sendVRData() {
        model?.orchestra?.vrFile = model?.premiumVrFile
        model?.orchestra?.vrPath = model?.premiumVRPath
        model?.orchestra?.instrumentName = model?.name
        model?.orchestra?.leftViewAngle = model?.leftViewAngle
        model?.orchestra?.rightViewAngle = model?.rightViewAngle
        model?.orchestra?.isPremium = true
        let isBought = model?.isPartBought ?? false && model?.isPremiumBought ?? false
        model?.orchestra?.playDuration = isBought ? nil : GlobalConstants.sampleDuration
//        GlobalConstants.Notification.sendVRData.fire(withObject: model?.orchestra?.JSONString)
        GlobalConstants.Notification.sendVRData.fire(withObject: model)
    }
    
}
