//
//  PlayerImageCollectionViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//

import UIKit

class PlayerImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    var image: String? {
        didSet {
            profileImageView.loadImage(url: image ?? "", placeholder: nil)//showImage(with: image, placeholderImage: nil)
        }
    }
    
    //MARK: UI Properties
    private(set) lazy var profileImageView: PlayerImage = {
        let imageView = PlayerImage(image: nil)//UIImageView(image: UIImage(named: "player_profile2"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.loadImage(url: image ?? "", placeholder: nil)
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        contentView.addSubview(profileImageView)
        profileImageView.fillSuperView()
    }
    
}
