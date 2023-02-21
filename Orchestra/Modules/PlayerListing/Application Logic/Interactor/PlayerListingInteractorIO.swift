//
//  PlayerListingInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

protocol PlayerListingInteractorInput: AnyObject {

    func getData(isRefresh: Bool, keyword: String?)
    func getLoginStatus()
    
}

protocol PlayerListingInteractorOutput: AnyObject {
    
    func obtained(_ models: [PlayerListingStructure])
    func obtained(point: PointHistory?)
    func obtained(_ hasMoreData: Bool)
    func obtained(_ error: Error)
    func obtainedLoginStatus(_ status: Bool)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)

}
