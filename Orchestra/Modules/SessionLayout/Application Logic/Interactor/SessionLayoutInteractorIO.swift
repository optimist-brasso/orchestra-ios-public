//
//  SessionLayoutInteractorIO.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 5/4/22.
//
//

import CoreGraphics

protocol SessionLayoutInteractorInput: AnyObject {
    
    func getData(with navigationBarHeight: CGFloat?)
    func getLoginStatus()
    func sendData()
    func getInstrument(of id: Int, musicianId: Int)
    
}

protocol SessionLayoutInteractorOutput: AnyObject {
    
    func obtained(_ model: SessionStructure)
    func obtained(_ error: Error)
    func obtainedLoginStatus(_ status: Bool)
    func obtainedInstrumentRedirection(id: Int, musicianId: Int)
    func obtainedMusicianRedirection(of id: Int)
    
}
