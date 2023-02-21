//
//  BillingHistoryViewInterface.swift
//  Orchestra
//
//  Created by rohit lama on 09/05/2022.
//
//



protocol BillingHistoryViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ models: [BillingHistoryMonthlyViewModel])
    func show(_ hasMoreData: Bool)
    func show(_ error: Error)
    
}
