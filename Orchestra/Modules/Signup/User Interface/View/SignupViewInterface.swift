//
//  SignupViewInterface.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 14/02/2022.
//
//



protocol SignupViewInterface: AnyObject, BaseViewInterface {
    
    func resposeSuccess()
    func show(_ error: Error)
    
}
