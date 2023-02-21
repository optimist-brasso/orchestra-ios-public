//
//  Image.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import UIKit

extension UIImage {
    
    func setTemplate() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
    
    var ratio: (width: CGFloat, height: CGFloat) {
        return (width: 1, height: (size.height / size.width))
    }
    
    func resized(_ width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

}

