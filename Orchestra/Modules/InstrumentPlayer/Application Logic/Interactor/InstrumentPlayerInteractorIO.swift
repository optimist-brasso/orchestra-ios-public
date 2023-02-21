//
//  InstrumentPlayerInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 14/06/2022.
//
//

protocol InstrumentPlayerInteractorInput: AnyObject {
    
    func getData()
    func sendData()
    func sendRecordedAudio(title: String, id: Int, duration: Int, file: AudioFile)
    
}

protocol InstrumentPlayerInteractorOutput: AnyObject {
    
    func obtained(_ model: InstrumentPlayerStructure)
    func audioFileUploaded()
    func obtained(_ error: Error)
    func obtainedBuySuccess()
    
}
