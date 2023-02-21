//
//  UITextView+Extension.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 31/08/2022.
//

import UIKit.UITextView

extension UITextView {
    
    func adjustHeight() {
//        translatesAutoresizingMaskIntoConstraints = true
        sizeToFit()
        isScrollEnabled = false
    }
    
}
