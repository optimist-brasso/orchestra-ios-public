//
//  UINavigationItem+Extension.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//

import UIKit.UINavigationItem

extension UINavigationItem {
    
    func setCenterLogo() {
        let imageView = UIImageView(frame: CGRect(x: .zero, y: .zero, width: 123, height: 18))
        imageView.contentMode = .scaleAspectFit
        imageView.image = GlobalConstants.Image.logo
        titleView = imageView
    }
    
    var leadingTitle: String? {
        get { return nil }
        set {
            let label = UILabel()
            label.textColor = .white
            label.text = newValue
            label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
            leftBarButtonItem = UIBarButtonItem(customView: label)
        }
    }
    
}
