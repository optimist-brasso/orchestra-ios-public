//
//  RecordingSettingsPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//
//

import Foundation

class RecordingSettingsPresenter {
    
	// MARK: Properties
    weak var view: RecordingSettingsViewInterface?
    var interactor: RecordingSettingsInteractorInput?
    var wireframe: RecordingSettingsWireframeInput?
    
    //MARK: Converting entities
    private func convert(_ model: RecordingSettingsStructure) -> RecordingSettingsViewModel {
        return RecordingSettingsViewModel(fileFormat: model.fileFormat,
                                          encodingQuality: model.encodingQuality,
                                          samplingRate: model.samplingRate,
                                          bitRate: model.bitRate,
                                          channel: model.channel)
    }
    
}

 // MARK: RecordingSettings module interface
extension RecordingSettingsPresenter: RecordingSettingsModuleInterface {
    
    func viewIsReady() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func select(value: String?, of type: RecordingSetting?) {
        interactor?.select(value: value, of: type)
    }
    
}

// MARK: RecordingSettings interactor output interface
extension RecordingSettingsPresenter: RecordingSettingsInteractorOutput {
    
    func obtained(_ model: RecordingSettingsStructure) {
        view?.hideLoading()
        view?.show(convert(model))
    }
    
}
