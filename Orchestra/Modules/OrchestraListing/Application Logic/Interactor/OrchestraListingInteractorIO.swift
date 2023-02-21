//
//  OrchestraListingInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

protocol OrchestraListingInteractorInput: AnyObject {
    
    func getData(isRefresh: Bool)
    func search(for keyword: String)
    func getLoginStatus()
    
}

protocol OrchestraListingInteractorOutput: AnyObject {

    func obtained(_ models: [OrchestraListingStructure])
    func obtained(point: PointHistory?)
    func obtained(_ error: Error)
    func obtainedLoginStatus(_ status: Bool)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)
    
}
