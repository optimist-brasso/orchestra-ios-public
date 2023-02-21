//
//  PurchasedContentListViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//



protocol PurchasedContentListViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ models: [PurchasedContentListViewModel])
    func show(_ models: [PurchasedModel])
    func endRefreshing()
    func show(_ error: Error)
    
}
