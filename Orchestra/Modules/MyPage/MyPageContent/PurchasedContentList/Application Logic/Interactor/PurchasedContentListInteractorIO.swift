//
//  PurchasedContentListInteractorIO.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

protocol PurchasedContentListInteractorInput: AnyObject {
    
    func getData()
    func search(for keyword: String)

}

protocol PurchasedContentListInteractorOutput: AnyObject {
    
    func obtained(_ models: [PurchasedContentListStructure])
    func obtained(_ models: [PurchasedModel])
    func obtained(_ error: Error)

}
