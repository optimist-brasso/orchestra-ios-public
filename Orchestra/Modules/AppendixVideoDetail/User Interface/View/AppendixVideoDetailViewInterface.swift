//
//  AppendixVideoDetailViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//
//



protocol AppendixVideoDetailViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ model: AppendixVideoDetailViewModel)
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func showLoginNeed()
    func show(_ downloadState: DownloadConstants.DownloadState, progress: Float?)
    func endRefreshing()
    func showDownloadStart()
    func showPlayState()
    func show(_ error: Error)
    
}
