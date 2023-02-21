//
//  HomeViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//
//



protocol HomeViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ models: [HomeRecommendationViewModel])
    func show(_ models: [HomeBannerViewModel])
    func show(point: PointHistory?)
    func endRefreshing()
    func showLoginNeed(for mode: OpenMode?)
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func show(_ error: Error)
    
}
