//
//  PlayerInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//
//


protocol PlayerInteractorInput: AnyObject {
    
    func getData()
    func favourite()
    func getLoginStatus()
    func isLogin() -> Bool 

}

protocol PlayerInteractorOutput: AnyObject {
    
    func obtained(_ model: PlayerStructure)
    func obtained(_ error: Error)
    func obtainedLoginNeed()
    func obtainedLoginStatus(_ status: Bool)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)
    func obtainedFavouriteStatus(_ status: Bool)
   
}
