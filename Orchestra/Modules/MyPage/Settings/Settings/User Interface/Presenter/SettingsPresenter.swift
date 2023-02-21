//
//  SettingsPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import Foundation

class SettingsPresenter {
    
	// MARK: Properties
    weak var view: SettingsViewInterface?
    var interactor: SettingsInteractorInput?
    var wireframe: SettingsWireframeInput?
    
    //MARK: Converting entites
    private func convert(_ model: SettingsStructure) -> SettingsViewModel {
        return SettingsViewModel(notificationStatus: model.notificationStatus,
                                 version: model.version,
                                 isLoggedIn: model.isLoggedIn)
    }
    
}

 // MARK: Settings module interface
extension SettingsPresenter: SettingsModuleInterface {
    
    func viewIsReady() {
        interactor?.getData()
    }
    
    func streamingDownloadSettings() {
        wireframe?.openStreamingDownloadSettings()
    }
    
    func recordingSettings() {
        wireframe?.openRecordingSettings()
    }
    
    func dataManagementSettings() {
        wireframe?.openDataManagementSettings()
    }
    
    func toggleNotificationStatus() {
        interactor?.toggleNotificationStatus()
    }
    
}

// MARK: Settings interactor output interface
extension SettingsPresenter: SettingsInteractorOutput {
    
    func obtained(_ model: SettingsStructure) {
        view?.show(convert(model))
    }
    
    func obtained(toggle: Bool) {
        view?.show(toggle: toggle)
    }
    
    func obtained(_ error: Error) {
        view?.show(error)
    }
    
}
