//
//  DataManagementSettingsInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//
//

protocol DataManagementSettingsInteractorInput: AnyObject {
    
    func getData()
    func deleteCache()
    func deleteDownload()

}

protocol DataManagementSettingsInteractorOutput: AnyObject {

    func obtained(_ model: DataManagementSettingsStructure)
    
}
