//
//  HallSoundAudioPlayerPresenter.swift
//  Orchestra
//
//  Created by rohit lama on 28/04/2022.
//
//

import Foundation

class HallSoundAudioPlayerPresenter {
    
    // MARK: Properties
    weak var view: HallSoundAudioPlayerViewInterface?
    var interactor: HallSoundAudioPlayerInteractorInput?
    var wireframe: HallSoundAudioPlayerWireframeInput?
    
    // MARK: Converting entities
    private func convert(_ model: HallSoundAudioPlayerStructure) ->  HallSoundAudioPlayerViewModel {
        return HallSoundAudioPlayerViewModel(title: model.title,
                                             titleJapanese: model.titleJapanese,
                                             image: model.image,
                                             venueTitle: model.venueTitle,
                                             seat: model.seat)
    }
    
}

// MARK: HallSoundAudioPlayer module interface
extension HallSoundAudioPlayerPresenter: HallSoundAudioPlayerModuleInterface {
    
    func viewIsReady() {
        interactor?.viewIsReady()
    }
    
    func playSong() {
        interactor?.playSong()
    }
    
    func audioSliderScrubbed(_ audioSliderValue: Float?) {
        interactor?.audioSliderScrubbed(audioSliderValue)
    }
    
    func forwardAudio() {
        interactor?.forwardAudio()
    }
    
    func reverseAudio() {
        interactor?.reverseAudio()
    }
    
}

// MARK: HallSoundAudioPlayer interactor output interface
extension HallSoundAudioPlayerPresenter: HallSoundAudioPlayerInteractorOutput {
    
    func showAudioDuration(_ time: String?) {
        view?.showAudioDuration(time)
    }
    
    func showAudioTimeElapsed(_ elapsedTime: String?) {
        view?.showAudioTimeElapsed(elapsedTime)
    }
    
    func syncAudioDurationAndSlider(_ audioDuration: Float?) {
        view?.syncAudioDurationAndSlider(audioDuration)
    }
    
    func syncAudioCurrentTimeAndSlider(_ audioTimeElapsed: Float?) {
        view?.syncAudioCurrentTimeAndSlider(audioTimeElapsed)
    }
    
    func showAudioPlayerDetail(_ model: HallSoundAudioPlayerStructure) {
        view?.showAudioPlayerDetail(convert(model))
    }
    
    func showPlayPauseStatus(_ isPlaying: Bool?) {
        view?.showPlayPauseStatus(isPlaying)
    }
    
}
