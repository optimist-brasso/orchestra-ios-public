//
//  IconWithLabelCollectionViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//  Copyright © 2022 Orchestra. All rights reserved.
//

import UIKit

class IconWithLabelCollectionViewCell: UICollectionViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var iconImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel?.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        titleLabel?.textAlignment = .center
    }
    
}
