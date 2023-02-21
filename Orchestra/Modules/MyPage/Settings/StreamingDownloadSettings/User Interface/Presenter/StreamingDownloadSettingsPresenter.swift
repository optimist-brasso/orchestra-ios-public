//
//  StreamingDownloadSettingsPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import Foundation

class StreamingDownloadSettingsPresenter {
    
	// MARK: Properties
    weak var view: StreamingDownloadSettingsViewInterface?
    var interactor: StreamingDownloadSettingsInteractorInput?
    var wireframe: StreamingDownloadSettingsWireframeInput?

    // MARK: Converting entities
    private func convert(_ model: StreamingDownloadSettingsStructure) -> StreamingDownloadSettingsViewModel {
        return StreamingDownloadSettingsViewModel(wifiStreamingOnly: model.wifiStreamingOnly,
                                                  mobileDataNotify: model.mobileDataNotify,
                                                  wifiDownloadOnly: model.wifiDownloadOnly)
    }
    
    private func convert(_ model: StreamingDownloadSettingsViewModel) -> StreamingDownloadSettingsStructure {
        return StreamingDownloadSettingsStructure(wifiStreamingOnly: model.wifiStreamingOnly,
                                                  mobileDataNotify: model.mobileDataNotify,
                                                  wifiDownloadOnly: model.wifiDownloadOnly)
    }
    
}

 // MARK: StreamingDownloadSettings module interface
extension StreamingDownloadSettingsPresenter: StreamingDownloadSettingsModuleInterface {
    
    func submit(_ model: StreamingDownloadSettingsViewModel) {
        interactor?.submit(convert(model))
    }
    
    func viewIsReady() {
        view?.showLoading()
        interactor?.getData()
    }
    
}

// MARK: StreamingDownloadSettings interactor output interface
extension StreamingDownloadSettingsPresenter: StreamingDownloadSettingsInteractorOutput {
    
    func obtained(_ model: StreamingDownloadSettingsStructure) {
        view?.hideLoading()
        view?.show(convert(model))
    }
    
}
