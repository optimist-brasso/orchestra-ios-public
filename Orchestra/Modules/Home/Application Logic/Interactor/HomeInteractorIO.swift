//
//  HomeInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//
//

protocol HomeInteractorInput: AnyObject {
    
    func getData(isRefresh: Bool)
    func getLoginStatus()
    func sendData(image: String?, title: String?, description: String?)

}

protocol HomeInteractorOutput: AnyObject {
    
    func obtained(models: [HomeRecommendationStructure])
    func obtained(models: [HomeBannerStructure])
    func obtained(_ error: Error)
    func obtainedLoginStatus(_ status: Bool)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)
    func obtained(point: PointHistory?)

}
