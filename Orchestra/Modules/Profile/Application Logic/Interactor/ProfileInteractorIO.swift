//
//  ProfileInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

protocol ProfileInteractorInput: AnyObject {
     
    var profile: ProfileStructure? { set get}
    
    func getData()

}

protocol ProfileInteractorOutput: AnyObject {

    func obtained(_ model: ProfileStructure)
    func obtained(_ error: Error)
    
}
