//
//  InstrumentDetailInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 6/13/22.
//
//

protocol InstrumentDetailInteractorInput: AnyObject {

    func getData()
    func checkLoginStatus()
    func sendData()
    func sendVRData()
    func downloadVideo(withWarning: Bool)
    func cancelDownload()
    func favourite()
    
}

protocol InstrumentDetailInteractorOutput: AnyObject {
    
    func obtained(_ model: InstrumentDetailStructure)
    func obtained(_ error: Error)
    func obtainedCartOpenNeed()
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)
    func obtainedLoginStatus(_ status: Bool)
    func obtained(_ downloadState: DownloadConstants.DownloadState, progress: Float?)
    func obtainedDownloadWarningNeed()
    func obtainedPlayState()
    func obtainedLoadingNeed()
    func obtainedDownloadStart()

}
