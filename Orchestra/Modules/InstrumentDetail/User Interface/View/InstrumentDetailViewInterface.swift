//
//  InstrumentDetailViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 6/13/22.
//
//

protocol InstrumentDetailViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ model: InstrumentDetailViewModel)
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func showLoginNeed()
    func show(_ downloadState: DownloadConstants.DownloadState, progress: Float?)
    func endRefreshing()
    func showDownloadStart()
    func showPlayState()
    func show(_ error: Error)
    
}
