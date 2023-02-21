//
//  OrchestraPlayerListInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/07/2022.
//
//

protocol OrchestraPlayerListInteractorInput: AnyObject {
    
    func getData(isRefresh: Bool)
    func getLoginStatus()

}

protocol OrchestraPlayerListInteractorOutput: AnyObject {

    func obtained(_ models: [OrchestraPlayerListStructure])
    func obtained(_ error: Error)
    func obtained(_ hasMoreData: Bool)
    func obtainedLoginStatus(_ status: Bool)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)
    
}
