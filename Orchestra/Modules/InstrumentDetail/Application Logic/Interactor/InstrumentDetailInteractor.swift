//
//  InstrumentDetailInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 6/13/22.
//
//

import Foundation
import Alamofire

class InstrumentDetailInteractor {
    
    // MARK: Properties
    weak var output: InstrumentDetailInteractorOutput?
    private let service: InstrumentDetailServiceType
    var id: Int?
    var orchestraId: Int?
    var musicianId: Int?
    private var model: Instrument?
    private var models: [SessionLayout]?
//    private var canPlay: Bool = false
    
    // MARK: Initialization
    init(service: InstrumentDetailServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(openCart), name: GlobalConstants.Notification.openCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBuy(_:)), name: GlobalConstants.Notification.didBuy.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didObtainDownloadStatus(notification:)), name: DownloadConstants.Notification.videoDownloadStatus.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetSessionLayout(_:)), name: GlobalConstants.Notification.getSessionLayout.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFavourite(_:)), name: GlobalConstants.Notification.didUpdateFavourite.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didClearDownload), name: GlobalConstants.Notification.didClearDownload.notificationName, object: nil)
    }
    
    //MARK: Converting functions
    private func convert(_ model: Instrument) -> InstrumentDetailStructure {
        return InstrumentDetailStructure(name: model.name,
                                         musician: model.musician?.name,
                                         vrFile: model.vrFile,
                                         vrThumbnail: model.vrThumbnail,
                                         description: model.description,
                                         orchestra: model.orchestra.flatMap(convert),
                                         isBought: model.isPartBought,
                                         isPremiumBought: model.isPremiumBought,
                                         price: "\(model.partPrice?.currencyMode ?? "0") \(LocalizedKey.points.value)",
                                         isDownloaded: !(service.fetchVrPath(of: model.vrFile?.fileName)?.isEmpty ?? true) || model.vrFile?.isEmpty ?? true,
                                         isFavourite: model.isFavourite)
    }
    
    private func convert(_ model: Orchestra) -> InstrumentDetailOrchestraStructure {
        return InstrumentDetailOrchestraStructure(title: model.title,
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
    
    // MARK: Other functions
    @objc private func didAddToCart() {
        output?.obtained(cartCount: service.cartCount)
    }
    
    @objc private func didReadNotification() {
        output?.obtained(notificationCount: service.notificationCount)
    }
    
    @objc private func openCart() {
        output?.obtainedCartOpenNeed()
    }
    
    @objc private func didBuy(_ notification: Notification) {
        if let model = model, let purchasedItems = notification.object as? [CartItem],
           let musicianId = model.musician?.id,
           let orchestraId = model.orchestra?.id,
           let index = purchasedItems.firstIndex(where: {musicianId == $0.musicianId &&
               orchestraId == $0.orchestraId /*&&
               ($0.sessionType == SessionType.part.rawValue || $0.sessionType == SessionType.combo.rawValue)*/ &&
               $0.orchestraType == OrchestraType.session.rawValue}) {
           
            if let purchasedItem = purchasedItems.element(at: index) {
                if purchasedItem.sessionType == SessionType.part.rawValue {
                    model.isPartBought = true
                } else if purchasedItem.sessionType == SessionType.combo.rawValue || purchasedItem.sessionType == SessionType.premium.rawValue {
                    model.isPremiumBought = true
                    model.isPartBought = true 
                }
            }
            output?.obtained(convert(model))
            output?.obtainedLoadingNeed()
            getData()
        }
    }
    
    @objc private func didObtainDownloadStatus(notification: Notification) {
        if let downloadModel = notification.object as? DownloadedMedia,
           downloadModel.fileName == model?.vrFile?.fileName {
            switch downloadModel.state {
            case .downloaded:
                model?.partVRPath = downloadModel.path
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
           id == session.session.instrument?.id,
           orchestraId == session.session.orchestra?.id,
           musicianId == session.session.musician?.id {
            self.model?.isFavourite = session.session.instrument?.isFavourite ?? false
            if let instrumentModel = self.model {
                output?.obtained(convert(instrumentModel))
            }
        }
    }
    
    @objc private func didClearDownload() {
        model?.partVRPath = nil
        if let model = model {
            output?.obtained(convert(model))
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: InstrumentDetail interactor input interface
extension InstrumentDetailInteractor: InstrumentDetailInteractorInput {
    
    func getData() {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
        if let id = id, let orchestraId = orchestraId, let musicianId = musicianId {
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
    
    func checkLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
    func sendData() {
        if let model = model {
            GlobalConstants.Notification.getInstrument.fire(withObject: model)
            GlobalConstants.Notification.getSessionLayout.fire(withObject: models)
        }
    }
    
    func sendVRData() {
        model?.orchestra?.isPremium = false
        model?.orchestra?.vrFile = model?.vrFile
        model?.orchestra?.vrPath = model?.partVRPath
        model?.orchestra?.instrumentName = model?.name
        model?.orchestra?.leftViewAngle = model?.leftViewAngle
        model?.orchestra?.rightViewAngle = model?.rightViewAngle
        model?.orchestra?.isBought = model?.isPremiumBought ?? false
        model?.orchestra?.playDuration = model?.isPartBought ?? false ? nil : GlobalConstants.sampleDuration
//        GlobalConstants.Notification.sendVRData.fire(withObject: model?.orchestra?.JSONString)
        GlobalConstants.Notification.sendVRData.fire(withObject: model)
    }
    
    private func setDownloadState() {
        if let downloadModel = model?.fetchDownloadedMedia(of: .part) {
            if !(downloadModel.path?.isEmpty ?? true) {
                model?.partVRPath = downloadModel.path?.currentLocalPath
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
    
    func downloadVideo(withWarning: Bool) {
        if URL(string: model?.vrFile ?? "") != nil,
           let downloadModel = model?.fetchDownloadedMedia(of: .part) {
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
        if let downloadModel = model?.fetchDownloadedMedia(of: .part) {
            DownloadManager.shared.cancelDownload(downloadModel)
        }
    }
    
    func favourite() {
        if NetworkReachabilityManager()?.isReachable ?? false {
            guard let id = orchestraId,
                  let instrumentId = self.id,
                  let musicianId = musicianId else {
                return
            }
            service.favourite(of: id, instrumentId: instrumentId, musicianId: musicianId, from: .part) { result in
                switch result {
                case .success(_):
                    break
                case .failure(_):
                    break
                }
            }
        } else {
            output?.obtained(GlobalConstants.Error.noInternet)
        }
    }
    
}
