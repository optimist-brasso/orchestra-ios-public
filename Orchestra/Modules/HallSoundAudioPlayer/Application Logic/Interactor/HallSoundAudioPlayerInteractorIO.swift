//
//  HallSoundAudioPlayerInteractorIO.swift
//  Orchestra
//
//  Created by rohit lama on 28/04/2022.
//
//

protocol HallSoundAudioPlayerInteractorInput: AnyObject {
    
    func viewIsReady()
    func playSong()
    func audioSliderScrubbed(_ audioSliderValue: Float?)
    func forwardAudio()
    func reverseAudio()
    
}

protocol HallSoundAudioPlayerInteractorOutput: AnyObject {
    
    func showAudioDuration(_ time: String?)
    func showAudioTimeElapsed(_ elapsedTime: String?)
    func syncAudioCurrentTimeAndSlider(_ audioTimeElapsed: Float?)
    func syncAudioDurationAndSlider(_ audioDuration: Float?)
    func showAudioPlayerDetail(_ model: HallSoundAudioPlayerStructure)
    func showPlayPauseStatus(_ isPlaying: Bool?)
    
}
