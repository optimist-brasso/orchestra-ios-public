//
//  BillingHistoryInteractorIO.swift
//  Orchestra
//
//  Created by rohit lama on 09/05/2022.
//
//

protocol BillingHistoryInteractorInput: AnyObject {
    
    func getData(isRefresh: Bool)

}

protocol BillingHistoryInteractorOutput: AnyObject {

    func obtained(_ models: [BillingHistoryMonthlyStructure])
    func obtained(_ error: Error)
    func obtained(_ hasMoreData: Bool)
    
}
