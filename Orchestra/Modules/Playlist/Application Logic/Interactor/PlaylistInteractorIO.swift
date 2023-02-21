//
//  PlaylistInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//

protocol PlaylistInteractorInput: AnyObject {
    
    func getData()
    func getData(isRefresh: Bool, type: OrchestraType, keyword: String?)
    func getLoginStatus()
    func favourite(of id: Int?, type: OrchestraType, instrumentId: Int?, musicianId: Int?)
    func search(for keyword: String, type: OrchestraType)

}

protocol PlaylistInteractorOutput: AnyObject {
    
    func obtained(_ models: [PlaylistStructure], isSession: Bool, reload: Bool)
    func obtained(_ error: Error)
    func obtainedLoginStatus(_ status: Bool)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)
    func obtainedLoginNeed()
    func obtained(hasMoreData: Bool)
    
}
