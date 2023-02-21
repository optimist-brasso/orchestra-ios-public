//
//  InstrumentPlayerModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 14/06/2022.
//
//

protocol InstrumentPlayerModuleInterface: AnyObject {
    
    func viewIsReady()
    func buy()
    func previousModule()
    func sendRecordedAudio(title: String, id: Int, duration: Int, file: AudioFile)
    
}
