//
//  RecordingSettingsInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//
//

protocol RecordingSettingsInteractorInput: AnyObject {
    
    func getData()
    func select(value: String?, of type: RecordingSetting?)

}

protocol RecordingSettingsInteractorOutput: AnyObject {
    
    func obtained(_ model: RecordingSettingsStructure)

}
