//
//  HallSoundAudioPlayerModuleInterface.swift
//  Orchestra
//
//  Created by rohit lama on 28/04/2022.
//
//

protocol HallSoundAudioPlayerModuleInterface: AnyObject {
    
    func viewIsReady()
    func playSong()
    func audioSliderScrubbed(_ audioSliderValue: Float?)
    func forwardAudio()
    func reverseAudio()
    
}
