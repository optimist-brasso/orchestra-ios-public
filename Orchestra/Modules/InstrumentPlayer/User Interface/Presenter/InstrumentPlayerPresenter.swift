//
//  InstrumentPlayerPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 14/06/2022.
//
//

import Foundation

class InstrumentPlayerPresenter {
    
	// MARK: Properties
    weak var view: InstrumentPlayerViewInterface?
    var interactor: InstrumentPlayerInteractorInput?
    var wireframe: InstrumentPlayerWireframeInput?

    // MARK: Converting entities
    private func convert(_ model: InstrumentPlayerStructure) -> InstrumentPlayerViewModel {
        return InstrumentPlayerViewModel(title: model.title,
                                         japaneseTitle: model.japaneseTitle,
                                         instrument: model.instrument,
                                         businessType: model.businessType,
                                         videoURL: model.videoURL,
                                         isPartBought: model.isPartBought,
                                         isPremiumBought: model.isPremiumBought,
                                         leftViewAngle: model.leftViewAngle,
                                         rightViewAngle: model.rightViewAngle)
    }
    
}

 // MARK: InstrumentPlayer module interface
extension InstrumentPlayerPresenter: InstrumentPlayerModuleInterface {
    
    func viewIsReady() {
        interactor?.getData()
    }
    
    func buy() {
        wireframe?.openInstrumentPlayerPopup()
        interactor?.sendData()
    }
    
    func previousModule() {
        wireframe?.openPreviousModule()
    }
    
    func sendRecordedAudio(title: String, id: Int, duration: Int, file: AudioFile) {
        interactor?.sendRecordedAudio(title: title, id: id, duration: duration, file: file)
    }
    
}

// MARK: InstrumentPlayer interactor output interface
extension InstrumentPlayerPresenter: InstrumentPlayerInteractorOutput {
    
    func obtained(_ model: InstrumentPlayerStructure) {
        view?.show(convert(model))
    }
    
    func audioFileUploaded() {
        view?.audioFileUploaded()
    }
    
    func obtained(_ error: Error) {
        view?.endLoading()
        view?.show(error)
    }
    
    func obtainedBuySuccess() {
        view?.endLoading()
        view?.show(NSError(domain: "error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.redownloadVideo.value]))
    }
    
}
