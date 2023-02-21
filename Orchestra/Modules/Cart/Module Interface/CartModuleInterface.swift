//
//  CartModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/05/2022.
//
//

protocol CartModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool)
    func remove(at index: Int)
    func select(at index: Int)
    func buy()
    func notification()
    
}
