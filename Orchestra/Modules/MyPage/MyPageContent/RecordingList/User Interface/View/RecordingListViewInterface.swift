//
//  RecordingListViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//



protocol RecordingListViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ models: [RecordingListViewModel])
    func show(_ hasMoreData: Bool)
    func endRefreshing()
    func show(_ error: Error)
    
}
