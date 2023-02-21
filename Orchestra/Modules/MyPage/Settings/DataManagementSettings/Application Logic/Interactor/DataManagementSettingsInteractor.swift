//
//  DataManagementSettingsInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//
//

import Foundation
import AlamofireImage

class DataManagementSettingsInteractor {
    
	// MARK: Properties
    weak var output: DataManagementSettingsInteractorOutput?
    private let service: DataManagementSettingsServiceType
    
    // MARK: Initialization
    init(service: DataManagementSettingsServiceType) {
        self.service = service
    }
    
}

// MARK: DataManagementSettings interactor input interface
extension DataManagementSettingsInteractor: DataManagementSettingsInteractorInput {
    
    func getData() {
        output?.obtained(DataManagementSettingsStructure(cacheSize: ByteCountFormatter.string(fromByteCount: Int64(URLCache.shared.currentDiskUsage), countStyle: .file),
                                                         downloadCompleteCount: DownloadManager.shared.downloadFilesCount,
                                                         capcityUsed: DownloadManager.shared.downloadFilesSize,
                                                         freeSpace: DownloadManager.shared.freeMemory))
    }
    
    func deleteDownload() {
        DownloadManager.shared.clearDownloads()
        let isDownloadInProgress = DownloadManager.shared.persistedVideos.count > .zero
        let realmModels: [DownloadedMediaRealmModel] = DatabaseHandler.shared.fetch(filter: isDownloadInProgress ? "path != nil" : "")
        DatabaseHandler.shared.delete(object: realmModels)
        getData()
        GlobalConstants.Notification.didClearDownload.fire()
    }
    
    func deleteCache() {
        URLCache.shared.removeAllCachedResponses()
        output?.obtained(DataManagementSettingsStructure(cacheSize: "0 KB",
                                                         downloadCompleteCount: DownloadManager.shared.downloadFilesCount,
                                                         capcityUsed: DownloadManager.shared.downloadFilesSize,
                                                         freeSpace: DownloadManager.shared.freeMemory))
    }
    
}
