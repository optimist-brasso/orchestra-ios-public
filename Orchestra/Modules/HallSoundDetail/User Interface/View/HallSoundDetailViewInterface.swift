//
//  HallSoundDetailViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//
//



protocol HallSoundDetailViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ model: HallSoundDetailViewModel)
    func showLoginNeed(for mode: OpenMode?)
    func showBuySuccess()
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func show(_ downloadState: DownloadConstants.DownloadState, progress: Float?)
//    func showAlreadyDownloadingState()
    func show(_ error: String)
    func showPlayStatus(of index: Int)
    func endRefreshing()
    func showFavouriteStatus(_ status: Bool)
    func showDownloadStart()
    func show(_ error: Error)
    
}
