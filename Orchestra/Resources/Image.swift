//
//  Image.swift
//  Orchestra
//
//  Created by manjil on 30/03/2022.
//

import UIKit

extension UIImage {
    
    private static func named(_ imageName: String) -> UIImage {
        guard let image = UIImage(named: imageName) else {
            assertionFailure("The image associated with name \(imageName) was not found. Please check you have spelled it correctly.")
            return UIImage()
        }
        return image
    }
    
    static let line = UIImage.named("line")
    static let twitter = UIImage.named("twitter")
    static let back = UIImage.named("back")
    static let facebook = UIImage.named("facebook")
    static let bin = UIImage.named("bin")
    static let logo = UIImage.named("logo")
    static let down = UIImage.named("down")
    static let filter = UIImage.named("filter")
    static let box = UIImage.named("box")
    static let cross = UIImage.named("cross")
    static let insta = UIImage.named("insta")
    static let profilePlaceholder = UIImage.named("profilePlaceholder")
    static let camera = UIImage.named("camera")
    static let imagePlaceholder = UIImage.named("imagePlaceholder")
    static let rightArrow = UIImage.named("right-arrow")
    static let leftArrow = UIImage.named("left-arrow")
    static let next = UIImage.named("next")
    static let prev = UIImage.named("prev")
    static let point = UIImage.named("point")
    static let coin = UIImage.named("coin")
    static let bg_1 = UIImage.named("1_bg")
    static let frame_1 = UIImage.named("1_frame")
    static let bg_2 = UIImage.named("2_bg")
    static let frame_2 = UIImage.named("2_frame")
    static let bg_3 = UIImage.named("3_bg")
    static let frame_3 = UIImage.named("3_frame")
    static let bg_4 = UIImage.named("4_bg")
    static let frame_4 = UIImage.named("4_frame")
    static let frame_5 = UIImage.named("5_frame")
    static let frame_6 = UIImage.named("6_frame")
    static let bg_7 = UIImage.named("7_bg")
    static let frame_7 = UIImage.named("7_frame")
    
}
