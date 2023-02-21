//
//  HallSoundDetailInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//
//

import Foundation
//import RealmSwift
import Alamofire

class HallSoundDetailInteractor {
    
    // MARK: Properties
    weak var output: HallSoundDetailInteractorOutput?
    private let service: HallSoundDetailServiceType
    var id: Int?
    var model: Orchestra?
    private var isDownloading = false
    
    // MARK: Initialization
    init(service: HallSoundDetailServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didBuy(_:)), name: GlobalConstants.Notification.didBuy.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didObtainDownloadStatus(notification:)), name: DownloadConstants.Notification.videoDownloadStatus.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didClearDownload), name: GlobalConstants.Notification.didClearDownload.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFavourite(_:)), name: GlobalConstants.Notification.didUpdateFavourite.notificationName, object: nil)
    }
    
    // MARK: Converting entities
    private func convert(_ model: Orchestra) -> HallSoundDetailStructure {
        model.hallsounds?.sort(by: {$0.position ?? .zero < $1.position ?? .zero})
        return HallSoundDetailStructure(title: model.title,
                                        titleJapanese: model.titleJapanese,
                                        description: model.description,
                                        composer: model.composer,
                                        band: model.band,
                                        conductor: model.conductor,
                                        organization: model.organization,
                                        venue: model.venueTitle,
                                        venueDescription: model.venueDescription,
                                        duration: model.duration?.time,
                                        releaseDate: model.releaseDate,
                                        liscenceNumber: model.liscenceNumber,
                                        isFavourite: model.isHallSoundFavourite,
                                        isBought: model.isHallSoundBought ?? false,
                                        image: model.venueDiagram,
                                        businessType: model.businessType,
                                        hallsounds: convert(model.hallsounds ?? []),
                                        isDownloaded: model.hallsounds?.allSatisfy({$0.fileLink?.isEmpty ?? true || $0.isDownloaded}))
    }
    
    private func convert(_ models: [HallSound]) -> [HallSoundDetailAudioStrcture] {
        return models.map({HallSoundDetailAudioStrcture(image: $0.image,
                                                        audioLink: $0.path ?? $0.fileLink,
                                                        type: $0.type,
                                                        position: $0.position)})
    }
    
    private func convert(_ model: HallSound) -> HallSoundDetailAudioStrcture {
        return HallSoundDetailAudioStrcture(image: model.image,
                                            audioLink: model.path ?? model.fileLink,
                                            type: model.type,
                                            position: model.position == nil ? nil : ((model.position ?? .zero) - 1))
    }
    
    //MARK: Other functions
    @objc private func didBuy(_ notification: Notification) {
        if let purchasedItems = notification.object as? [CartItem],
           purchasedItems.contains(where: {$0.orchestraId == id &&
               $0.orchestraType == OrchestraType.hallSound.rawValue}) {
            model?.isHallSoundBought = true
            output?.obtainedBuySuccess()
        }
    }
    
    @objc private func didObtainDownloadStatus(notification: Notification) {
        guard model?.isHallSoundBought ?? false else {
            return
        }
        if let downloadModel = notification.object as? DownloadedMedia,
           let fileContainingHallsounds = model?.hallsounds?.filter({$0.fileLink?.fileName == downloadModel.fileName}),
           !fileContainingHallsounds.isEmpty {
            switch downloadModel.state {
            case .downloaded:
                isDownloading = false
                fileContainingHallsounds.forEach({
                    $0.path = downloadModel.path
                    $0.isDownloaded = true
                    $0.totalSize = downloadModel.totalSize
                    $0.downloadedSize = downloadModel.downloadedSize
                })
                if let model = model {
                    output?.obtained(convert(model))
                }
                if let index = model?.hallsounds?.firstIndex(where: {$0.fileLink?.fileName == downloadModel.fileName}) {
                    output?.obtainedPlayStatus(of: index)
                }
                output?.obtained(.downloaded, progress: nil)
            case .downloading:
                let hallSounds = model?.hallsounds ?? []
                if let index = hallSounds.firstIndex(where: {$0.fileLink?.fileName == downloadModel.fileName}),
                   let hallSound = hallSounds.element(at: index) {
                    hallSound.downloadedSize = downloadModel.downloadedSize
                    hallSound.totalSize = downloadModel.totalSize
                }
                output?.obtained(.downloading, progress: (downloadModel.downloadedSize ?? .zero) / (downloadModel.totalSize ?? .zero))
                isDownloading = true
            case .notDownloaded :
                isDownloading = false
                output?.obtained(.notDownloaded, progress: nil)
            }
        } else if notification.object is NSError {
            output?.obtained(NSError(domain: "space-error", code: 28, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.diskFull.value]))
        }
    }
    
    @objc private func didAddToCart() {
        output?.obtained(cartCount: service.cartCount)
    }
    
    @objc private func didReadNotification() {
        output?.obtained(notificationCount: service.notificationCount)
    }
    
    @objc private func didClearDownload() {
        model?.hallsounds?.forEach({
            $0.path = nil
            $0.isDownloaded = false
            $0.totalSize = nil
            $0.downloadedSize = nil
        })
        if let model = model {
            output?.obtained(convert(model))
        }
    }
    
    @objc private func didUpdateFavourite(_ notification: Notification) {
        if let model = notification.object as? Favourite,
           model.orchestra?.type == OrchestraType.hallSound.rawValue,
           model.orchestra?.id == id {
            output?.obtainedFavouriteStatus(model.orchestra?.isFavourite ?? false)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: HallSoundDetail interactor input interface
extension HallSoundDetailInteractor: HallSoundDetailInteractorInput {
    
    func getData() {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
        if let id = id {
            service.fetchOrchestraDetail(of: id) { [weak self] result in
                switch result {
                case .success(let model):
//                    let isFirstLoad = self?.model == nil
                    self?.model = model
//                    if isFirstLoad {
                        self?.setDownloadState()
//                    }
                    if let structure = self?.convert(model) {
                        self?.output?.obtained(structure)
                    }
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        }
    }
    
    func favourite() {
        if NetworkReachabilityManager()?.isReachable ?? false {
            guard service.isLoggedIn else {
                output?.obtainedLoginNeed()
                return
            }
            guard let model = model else { return }
            service.favouriteOrchestra(model, for: .hallSound) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.output?.obtainedFavouriteStatus(model.orchestra?.isFavourite ?? false)
                case .failure(_):
                    break
                }
            }
            //        service.favouriteOrchestra(of: id ?? .zero, for: .hallSound) { result in
            //            switch result {
            //            case .success(_):
            //                NotificationCenter.default.post(name: GlobalConstants.Notification.didUpdateFavouriteItem.notificationName, object: nil)
            //            case .failure(_):
            //                break
            //            }
            //        }
        } else {
            output?.obtained(GlobalConstants.Error.noInternet)
        }
    }
    
    func checkLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
    func sendData() {
        GlobalConstants.Notification.didBuy.fire(withObject: model)
    }
    
    private func setDownloadState() {
        guard model?.isHallSoundBought ?? false else {
            return
        }
        if let downloadModels = model?.fetchDownloadedMedia(of: .hallSound) {
            let hallSounds = model?.hallsounds ?? []
            downloadModels.forEach { downloadModel in
                if downloadModel.path?.isEmpty ?? true {
                    if let downloadingModel = DownloadManager.shared.persistedVideos.first(where: {$0.key.fileName == downloadModel.fileName})?.value,
                       downloadingModel.state == .downloading {
                        output?.obtained(.downloading, progress: downloadingModel.progress)
                        return
                    }
                    output?.obtained(.notDownloaded, progress: nil)
                } else {
                    hallSounds.filter({$0.fileLink?.fileName == downloadModel.fileName}).forEach({
                        $0.path = downloadModel.path?.currentLocalPath
                        $0.isDownloaded = true
                    })
                }
                //MARK: To do
                //                else {
                //                    if let direction = HallSoundDirection(rawValue: $0.sessionType?.lowercased() ?? ""),
                //                       let index = hallSounds.firstIndex(where: {$0.type?.lowercased() == direction.rawValue}),
                //                       let hallSound = hallSounds.element(at: index) {
                //                        hallSound.isDownloaded = true
                //                        hallSound.path = $0.path
                //                    }
                //                }
            }
            if hallSounds.allSatisfy({$0.isDownloaded}) {
                output?.obtained(.downloaded, progress: nil)
            }
        }
    }
    
    func download(withWarning: Bool) {
        if let downloadModels = model?.fetchDownloadedMedia(of: .hallSound) {
            
            func download() {
                downloadModels.forEach({ downloadModel in
                    if URL(string: downloadModel.url ?? "") != nil, downloadModel.path?.isEmpty ?? true {
                        isDownloading = true
                        DownloadManager.shared.download(downloadModel)
                    }
                })
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
    
    func download(withWarning: Bool, index: Int) {
        if isDownloading {
            output?.obtained(LocalizedKey.downloadInProgress.value)
            return
        }
        if let downloadModels = model?.fetchDownloadedMedia(of: .hallSound, index: index) {
            
            func download() {
                downloadModels.forEach({ downloadModel in
                    if URL(string: downloadModel.url ?? "") != nil, downloadModel.path?.isEmpty ?? true {
                        DownloadManager.shared.download(downloadModel)
                        output?.obtainedDownloadStart()
                    }
                })
            }
            
            if let downloadModel = downloadModels.first, !(downloadModel.path?.isEmpty ?? true) {
                output?.obtainedPlayStatus(of: index)
                return
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
        if let downloadModels = model?.fetchDownloadedMedia(of: .hallSound) {
            downloadModels.forEach({
                DownloadManager.shared.cancelDownload($0)
            })
        }
    }
    
}
