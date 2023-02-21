//
//  PremiumVideoDetailsInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

protocol PremiumVideoDetailsInteractorInput: AnyObject {

    func getData()
    func getFromApiData()
    func getLoginStatus()
    func sendData()
    func download(withWarning: Bool)
    func cancelDownload()
    func favourite()
    func sendVRData()
}

protocol PremiumVideoDetailsInteractorOutput: AnyObject {
    
    func obtained(_ model: PremiumVideoDetailsStructure)
    func obtained(_ error: Error)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)
    func obtainedLoginStatus(_ status: Bool)
    func obtained(_ downloadState: DownloadConstants.DownloadState, progress: Float?)
    func obtainedDownloadWarningNeed()
    func obtainedPlayState()
    func obtainedLoadingNeed()
    func obtainedDownloadStart()

}
