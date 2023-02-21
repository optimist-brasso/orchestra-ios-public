//
//  CheckBox.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 21/02/2022.
//

import Foundation
import UIKit

class CheckBox: UIButton {
    
    // Images
    let checkedImage = UIImage(named: "checkboxSelected")
    let uncheckedImage = UIImage(named: "checkbox")
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func setup() {
        curve = 2
        set(of: .black)
        addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
//        setImage(nil, for: .normal)
        setImage(checkedImage, for: .selected)
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isSelected.toggle()
        }
    }
    
}
