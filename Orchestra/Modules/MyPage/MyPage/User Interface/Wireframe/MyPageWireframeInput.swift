//
//  MyPageWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//  Copyright © 2022 Orchestra. All rights reserved.
//



protocol MyPageWireframeInput: WireframeInput {
    
    func openNotification()
    func openCart()
    func openLogin(for mode: OpenMode?)
    
}
