//
//  SettingsInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

protocol SettingsInteractorInput: AnyObject {
    
    func getData()
    func toggleNotificationStatus()

}

protocol SettingsInteractorOutput: AnyObject {

    func obtained(_ model: SettingsStructure)
    func obtained(toggle: Bool)
    func obtained(_ error: Error)
    
}
