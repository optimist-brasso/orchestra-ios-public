//
//  HallSoundAudioPlayerViewInterface.swift
//  Orchestra
//
//  Created by rohit lama on 28/04/2022.
//
//

protocol HallSoundAudioPlayerViewInterface: AnyObject {
    
    func showAudioDuration(_ time: String?)
    func showAudioTimeElapsed(_ timeElapsed: String?)
    func syncAudioCurrentTimeAndSlider(_ audioTimeElapsed: Float?)
    func syncAudioDurationAndSlider(_ audioDuration: Float?)
    func showAudioPlayerDetail(_ model: HallSoundAudioPlayerViewModel)
    func showPlayPauseStatus(_ isPlaying: Bool?)
    
}
