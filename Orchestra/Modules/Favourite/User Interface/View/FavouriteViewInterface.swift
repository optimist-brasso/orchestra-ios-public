//
//  FavouriteViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/04/2022.
//
//



protocol FavouriteViewInterface: AnyObject, BaseViewInterface {
    
    func show(cartCount: Int)
    func remove(model: FavouriteViewModel) 
    func show(notificationCount: Int)
    func showFavouriteList()
    func show(_ models: [FavouriteViewModel], type: OrchestraType)
    func show(hasMoreData: Bool)
    func show(_ error: Error)
    
}
