//
//  SplashViewInterface.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 12/04/2022.
//
//



protocol SplashViewInterface: AnyObject, BaseViewInterface {

    func startLoading()
    func stopLoading()
    func obtainedSuccess()
    func show(_ error: Error)
    
}
