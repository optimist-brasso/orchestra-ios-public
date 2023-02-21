//
//  RecordingListInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

protocol RecordingListInteractorInput: AnyObject {
    
    func getData(isRefresh: Bool, keyword: String?)
    func openRecordPlayer(of index: Int)

}

protocol RecordingListInteractorOutput: AnyObject {
    
    func obtained(_ models: [RecordingListStructure])
    func obtained(_ error: Error)
    func obtained(_ hasMoreData: Bool)

}
