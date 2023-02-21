//
//  BaseScreen.swift
//  Orchestra
//
//  Created by manjil on 30/03/2022.
//

import UIKit

class BaseScreen: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        create()
    }
    
    /// Coder initializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        create()
    }
    
    func create() {
        backgroundColor = .white
    }
    
}
