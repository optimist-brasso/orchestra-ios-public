//
//  SearchInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//

protocol SearchInteractorInput: AnyObject {
    
    func getData(isRefresh: Bool, type: OrchestraType, keyword: String?)
    func getLoginStatus()
    func search(for keyword: String)
    func favourite(of id: Int?, type: OrchestraType, instrumentId: Int?, musicianId: Int?)

}

protocol SearchInteractorOutput: AnyObject {
    
    func obtained(_ models: [SearchStructure], isSession: Bool, reload: Bool)
    func obtained(_ session: SearchStructure)
    func obtainedLoginStatus(_ status: Bool)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)
    func obtained(_ error: Error)
    func obtainedLoginNeed()
    func obtained(hasMoreData: Bool)
    func obtainedHideLoading()

}
