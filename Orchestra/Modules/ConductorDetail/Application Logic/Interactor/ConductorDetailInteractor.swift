//
//  ConductorDetailInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//
//

import Foundation
import AVFoundation
import RealmSwift
import Alamofire

struct OrchestraFavorite {
    let id: Int
    let type: OrchestraType
    let interactor: Any?
}

class ConductorDetailInteractor {
    
    // MARK: Properties
    weak var output: ConductorDetailInteractorOutput?
    private let service: ConductorDetailServiceType
    var id: Int?
    private var model: Orchestra?
    
    // MARK: Initialization
    init(service: ConductorDetailServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didObtainDownloadStatus(notification:)), name: DownloadConstants.Notification.videoDownloadStatus.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didClearDownload), name: GlobalConstants.Notification.didClearDownload.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateFavourite(_:)), name: GlobalConstants.Notification.didUpdateFavourite.notificationName, object: nil)
    }
    
    // MARK: Converting entities
    private func convert(_ model: Orchestra) -> ConductorDetailStructure {
        let titleJapanese = model.titleJapanese?.isEmpty ?? true ? "" : "/\(model.titleJapanese ?? "")"
        return ConductorDetailStructure(title: "\(model.title ?? "")\(titleJapanese)",
                                        image: model.image,
                                        description: model.description,
                                        composer: model.composer,
                                        conductor: model.conductor,
                                        venue: model.venueTitle,
                                        duration: model.duration?.time,
                                        releaseDate: model.releaseDate,
                                        organization: model.organization,
                                        businessType: model.businessType,
                                        band: model.band,
                                        liscenceNumber: model.liscenceNumber,
                                        organizationDiagram: model.organizationDiagram,
                                        isFavourite: model.isConductorFavourite,
                                        vrFile: model.vrFile,
                                        vrThumbnail: model.vrThumbnail,
                                        isDownloaded: !(service.fetchVrPath(of: model.vrFile?.fileName)?.isEmpty ?? true) || model.vrFile?.isEmpty ?? true)
    }
    
    //MARK: Other functions
    @objc private func didAddToCart() {
        output?.obtained(cartCount: service.cartCount)
    }
    
    @objc private func didReadNotification() {
        output?.obtained(notificationCount: service.notificationCount)
    }
    
    @objc private func didObtainDownloadStatus(notification: Notification) {
        if let downloadModel = notification.object as? DownloadedMedia,
           downloadModel.fileName == model?.vrFile?.fileName {
            switch downloadModel.state {
            case .downloaded:
                model?.vrPath = downloadModel.path
                output?.obtainedPlayState()
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
    
    @objc private func didClearDownload() {
        model?.vrPath = nil
        if let model = model {
            output?.obtained(convert(model))
        }
    }
    
    @objc private func didUpdateFavourite(_ notification: Notification) {
        if let model = notification.object as? Favourite,
           model.orchestra?.type == OrchestraType.conductor.rawValue,
           model.orchestra?.id == id {
            let isFavourite = model.orchestra?.isFavourite ?? false
            self.model?.isConductorFavourite = isFavourite
            output?.obtainedFavouriteStatus(isFavourite)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: ConductorDetail interactor input interface
extension ConductorDetailInteractor: ConductorDetailInteractorInput {
    
    func getData() {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
        if let id = id {
            service.fetchOrchestraDetail(of: id) { [weak self] result in
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
        }
    }
    
    func favourite() {
        if NetworkReachabilityManager()?.isReachable == true {
            guard service.isLoggedIn else {
                output?.obtainedLoginNeed()
                return
            }
            guard let model = model else { return }
            service.favouriteOrchestra(model) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.output?.obtainedFavouriteStatus(model.orchestra?.isFavourite ?? false)
                case .failure(_):
                    break
                }
            }
        } else {
            output?.obtained(GlobalConstants.Error.noInternet)
        }
    }
    
    func getLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
    func sendVRData() {
        let model = Instrument()
        model.orchestra = self.model
        model.isPartBought = true
        model.isPremiumBought = true
//        model?.isBought = true
        GlobalConstants.Notification.sendVRData.fire(withObject: model)
    }
    
    private func setDownloadState() {
        if let downloadModel = model?.fetchDownloadedMedia(of: .conductor).first {
            if downloadModel.path?.isEmpty ?? true {
                if let downloadingModel = DownloadManager.shared.persistedVideos.first(where: {$0.key.fileName == downloadModel.fileName})?.value,
                   downloadingModel.state == .downloading {
                    output?.obtained(.downloading, progress: downloadingModel.progress)
                    return
                }
                output?.obtained(.notDownloaded, progress: nil)
            } else {
                model?.vrPath = downloadModel.path?.currentLocalPath
                output?.obtained(.downloaded, progress: nil)
            }
        }
    }
    
    func downloadVideo(withWarning: Bool) {
        if URL(string: model?.vrFile ?? "") != nil,
           let downloadModel = model?.fetchDownloadedMedia(of: .conductor).first {
            func download() {
                if NetworkReachabilityManager()?.isReachable == true {
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
        if let downloadModel = model?.fetchDownloadedMedia(of: .conductor).first {
            DownloadManager.shared.cancelDownload(downloadModel)
        }
    }
    
}
