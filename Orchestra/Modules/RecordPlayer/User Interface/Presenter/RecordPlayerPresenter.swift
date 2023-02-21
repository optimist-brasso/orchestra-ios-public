//
//  RecordPlayerPresenter.swift
//  Orchestra
//
//  Created by rohit lama on 11/05/2022.
//
//

import Foundation

class RecordPlayerPresenter {
    
	// MARK: Properties
    weak var view: RecordPlayerViewInterface?
    var interactor: RecordPlayerInteractorInput?
    var wireframe: RecordPlayerWireframeInput?

    // MARK: Converting entities
    private func convert(_ model: RecordPlayerStructure) -> RecordPlayerViewModel {
        return RecordPlayerViewModel(title: model.title,
                                     edition: model.edition,
                                     date: model.date,
                                     duration: model.duration,
                                     image: model.image,
                                     path: model.path)
    }

}

 // MARK: RecordPlayer module interface
extension RecordPlayerPresenter: RecordPlayerModuleInterface {
    
    func viewIsReady() {
        interactor?.viewIsReady()
    }
    
    func playRecording() {
        interactor?.playRecording()
    }
    
    func audioSliderScrubbed(_ value: Float) {
        interactor?.audioSliderScrubbed(value)
    }
    
    func viewWillDimiss() {
        interactor?.viewWillDismiss()
    }
    
    func forwardRecording() {
        interactor?.forwardRecording()
    }
    
    func reverseRecording() {
        interactor?.reverseRecording()
    }
    
}

// MARK: RecordPlayer interactor output interface
extension RecordPlayerPresenter: RecordPlayerInteractorOutput {
    
    func obtained(_ model: RecordPlayerStructure) {
        view?.obtained(convert(model))
    }
    
    func showIsPlaying(_ isPlaying: Bool) {
        view?.showIsPlaying(isPlaying)
    }
    
    func showAudioCurrentTime(_ currentTime: String) {
        view?.showAudioCurrentTime(currentTime)
    }
    
    func syncAudioAndSlider(_ currentTime: Float) {
        view?.syncAudioAndSlider(currentTime)
    }
    
    func showTotalDuration(_ durationString: String, _ durationFloat: Float) {
        view?.showTotalDuration(durationString, durationFloat)
    }
    
}
