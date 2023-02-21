//
//  RecordPlayerInteractorIO.swift
//  Orchestra
//
//  Created by rohit lama on 11/05/2022.
//
//

protocol RecordPlayerInteractorInput: AnyObject {
    
    func viewIsReady()
    func playRecording()
    func audioSliderScrubbed(_ value: Float)
    func forwardRecording()
    func reverseRecording()
    func viewWillDismiss()

}

protocol RecordPlayerInteractorOutput: AnyObject {

    func obtained(_ model: RecordPlayerStructure)
    func showIsPlaying(_ isPlaying: Bool)
    func showAudioCurrentTime(_ currentTime: String)
    func syncAudioAndSlider(_ currentTime: Float)
    func showTotalDuration(_ durationString: String, _ durationFloat: Float)
    
}
