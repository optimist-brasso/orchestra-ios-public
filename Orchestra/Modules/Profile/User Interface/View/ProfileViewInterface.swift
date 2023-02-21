//
//  ProfileViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//



protocol ProfileViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ model: ProfileViewModel)
    func show(_ error: Error)
    
}
