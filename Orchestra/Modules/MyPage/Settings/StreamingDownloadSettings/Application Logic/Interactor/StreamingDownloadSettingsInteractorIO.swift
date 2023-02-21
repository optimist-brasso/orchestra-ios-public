//
//  StreamingDownloadSettingsInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

protocol StreamingDownloadSettingsInteractorInput: AnyObject {
    
    func getData()
    func submit(_ model: StreamingDownloadSettingsStructure)

}

protocol StreamingDownloadSettingsInteractorOutput: AnyObject {

    func obtained(_ model: StreamingDownloadSettingsStructure)
    
}
