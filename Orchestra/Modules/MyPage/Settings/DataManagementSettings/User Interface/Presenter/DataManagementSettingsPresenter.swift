//
//  DataManagementSettingsPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//
//

import Foundation

class DataManagementSettingsPresenter {
    
	// MARK: Properties
    weak var view: DataManagementSettingsViewInterface?
    var interactor: DataManagementSettingsInteractorInput?
    var wireframe: DataManagementSettingsWireframeInput?

    // MARK: Converting entities
    private func convert(_ model: DataManagementSettingsStructure) -> DataManagementSettingsViewModel {
        return DataManagementSettingsViewModel(cacheSize: model.cacheSize,
                                               downloadCompleteCount: model.downloadCompleteCount,
                                               capcityUsed: model.capcityUsed,
                                               freeSpace: model.freeSpace)
    }
    
}

 // MARK: DataManagementSettings module interface
extension DataManagementSettingsPresenter: DataManagementSettingsModuleInterface {
    
    func viewIsReady() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func deleteCache() {
        view?.showLoading()
        interactor?.deleteCache()
    }
    
    func deleteDownload() {
        view?.showLoading()
        interactor?.deleteDownload()
    }
    
}

// MARK: DataManagementSettings interactor output interface
extension DataManagementSettingsPresenter: DataManagementSettingsInteractorOutput {
    
    func obtained(_ model: DataManagementSettingsStructure) {
        view?.hideLoading()
        view?.show(convert(model))
    }
    
}
