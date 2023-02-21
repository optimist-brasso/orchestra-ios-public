//
//  RoundedImageView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/04/2022.
//

import UIKit.UIImageView

class RoundedImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        rounded()
    }

}
