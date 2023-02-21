//
//  ConductorDetailInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//
//



protocol ConductorDetailInteractorInput: AnyObject {
    
    func getData()
    func favourite()
    func getLoginStatus()
    func sendVRData()
    func downloadVideo(withWarning: Bool)
    func cancelDownload()
//    func makeFavoriteOrUn(param: [String: Any], completion: @escaping (Result<ResponseMessage, Error>) -> Void)
}

protocol ConductorDetailInteractorOutput: AnyObject {

    func obtained(_ model: ConductorDetailStructure)
    func obtained(_ error: Error)
    func obtainedLoginNeed()
    func obtainedLoginStatus(_ status: Bool)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)
    func obtained(_ downloadState: DownloadConstants.DownloadState, progress: Float?)
    func obtainedPlayState() 
    func obtainedDownloadWarningNeed()
    func obtainedDownloadStart()
    func obtainedFavouriteStatus(_ status: Bool)
    
}
