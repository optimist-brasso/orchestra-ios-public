//
//  BuyPointModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/09/2022.
//
//

protocol BuyPointModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool)
    func buy(at index: String)
    func gotoFreePoint()
    func cart()
    func notification()
}
