//
//  PremiumVideoDetailsViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

protocol PremiumVideoDetailsViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ model: PremiumVideoDetailsViewModel)
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func showLoginNeed()
    func show(_ downloadState: DownloadConstants.DownloadState, progress: Float?)
    func endRefreshing()
    func showDownloadStart()
    func showPlayState()
    func show(_ error: Error)

}
