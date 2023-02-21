//
//  AppendixVideoDetailInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//
//

protocol AppendixVideoDetailInteractorInput: AnyObject {
    
    func getFromApiData()
    func getData()
    func getLoginStatus()
    func sendData()
    func download(withWarning: Bool)
    func cancelDownload()
    func favourite()
//    func sendVRData()
    
}

protocol AppendixVideoDetailInteractorOutput: AnyObject {

    func obtained(_ model: AppendixVideoDetailStructure)
    func obtained(_ error: Error)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)
    func obtainedLoginStatus(_ status: Bool)
    func obtained(_ downloadState: DownloadConstants.DownloadState, progress: Float?)
    func obtainedDownloadWarningNeed()
    func obtainedPlayState()
    func obtainedDownloadStart()
    
}
