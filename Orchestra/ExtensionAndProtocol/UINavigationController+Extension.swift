//
//  UINavigationController+Extension.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 19/07/2022.
//

import UIKit.UINavigationController

extension UINavigationController {
    
    func setNavigationColor(color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
//        navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationBar.shadowImage = UIImage()
    }
    
}
