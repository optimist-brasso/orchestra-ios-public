//
//  BillingHistoryModuleInterface.swift
//  Orchestra
//
//  Created by rohit lama on 09/05/2022.
//
//

protocol BillingHistoryModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool)
    
}
