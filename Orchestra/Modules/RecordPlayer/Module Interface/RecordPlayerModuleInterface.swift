//
//  RecordPlayerModuleInterface.swift
//  Orchestra
//
//  Created by rohit lama on 11/05/2022.
//
//

protocol RecordPlayerModuleInterface: AnyObject {
    
    func viewIsReady()
    func playRecording()
    func audioSliderScrubbed(_ value: Float)
    func viewWillDimiss()
    func forwardRecording()
    func reverseRecording()
    
}
