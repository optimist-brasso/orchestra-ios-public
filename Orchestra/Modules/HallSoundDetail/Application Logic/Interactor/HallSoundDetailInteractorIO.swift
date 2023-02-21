//
//  HallSoundDetailInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//
//

protocol HallSoundDetailInteractorInput: AnyObject {
    
    func getData()
    func favourite()
    func checkLoginStatus()
    func sendData()
    func download(withWarning: Bool)
    func download(withWarning: Bool, index: Int)
    func cancelDownload()

}

protocol HallSoundDetailInteractorOutput: AnyObject {
    
    func obtained(_ model: HallSoundDetailStructure)
    func obtained(_ error: Error)
    func obtainedLoginNeed()
    func obtainedBuySuccess()
    func obtainedLoginStatus(_ status: Bool)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)
    func obtained(_ downloadState: DownloadConstants.DownloadState, progress: Float?)
    func obtainedDownloadWarningNeed()
//    func obtainedAlreadyDownloadingState()
    func obtained(_ error: String)
    func obtainedPlayStatus(of index: Int)
    func obtainedFavouriteStatus(_ status: Bool)
    func obtainedDownloadStart()

}
