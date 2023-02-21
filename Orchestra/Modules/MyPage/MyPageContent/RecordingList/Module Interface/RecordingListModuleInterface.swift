//
//  RecordingListModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

protocol RecordingListModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool, keyword: String?)
    func openRecordPlayer(of index: Int)
    
}
