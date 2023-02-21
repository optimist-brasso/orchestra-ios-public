//
//  PlayerModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//
//

import Combine

protocol PlayerModuleInterface: AnyObject {
    
    var response: PassthroughSubject<(Bool, String), Never> { get set}
    func viewIsReady(withLoading: Bool)
    func notification()
    func listing()
    func favourite()
    func login(for mode: OpenMode?)
    func website(of url: String?)
    func cart()
//    func sessionDetail(of id: Int?)
    func instrumentDetail(instrumentId: Int?, orchestraId: Int?, musicianId: Int?, isVRAvailable:Bool?)
    
}
