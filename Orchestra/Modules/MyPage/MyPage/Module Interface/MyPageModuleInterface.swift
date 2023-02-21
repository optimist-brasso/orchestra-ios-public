//
//  MyPageModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//  Copyright © 2022 Orchestra. All rights reserved.
//

protocol MyPageModuleInterface: AnyObject {
    
    func viewIsReady()
    func notification()
    func cart()
    func login(for mode: OpenMode?)
    func logout()
    
}
