//
//  RecordPlayerViewInterface.swift
//  Orchestra
//
//  Created by rohit lama on 11/05/2022.
//
//

protocol RecordPlayerViewInterface: AnyObject {
    
    func obtained(_ model: RecordPlayerViewModel)
    func showIsPlaying(_ isPlaying: Bool)
    func showAudioCurrentTime(_ currentTime: String)
    func syncAudioAndSlider(_ currentTime: Float)
    func showTotalDuration(_ durationString: String, _ durationFloat: Float)
    
}
