//
//  CartViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/05/2022.
//
//



protocol CartViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ models: [CartViewModel])
    func show(_ hasMoreData: Bool)
    func endRefreshing()
    func show(_ notificationCount: Int)
    func show(_ error: Error)
    
}
