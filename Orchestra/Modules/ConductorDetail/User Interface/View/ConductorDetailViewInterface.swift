//
//  ConductorDetailViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//
//



protocol ConductorDetailViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ model: ConductorDetailViewModel)
    func showLoginNeed(for mode: OpenMode?)
    func endRefreshing()
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func show(_ downloadState: DownloadConstants.DownloadState, progress: Float?)
    func showDownloadStart()
    func showPlayState()
    func showFavouriteStatus(_ status: Bool)
    func show(_ error: Error)
    
}
