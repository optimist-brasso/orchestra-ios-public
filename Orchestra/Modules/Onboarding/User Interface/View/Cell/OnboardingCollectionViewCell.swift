//
//  OnboardingCollectionViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/01/2023.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    var model: OnboardingItem! {
        didSet {
            setData()
        }
    }
    
    //MARK: UI Properties
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .bg_1
        return image
    }()
    
    private lazy var baseImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var bottomView: UIView = {
        let image = UIView()
        image.backgroundColor = .clear
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        let views = [backgroundImage, baseImage, bottomView]
        
        views.forEach(contentView.addSubview(_:))
        
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            baseImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            baseImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            baseImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            baseImage.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            bottomView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func setData() {
        backgroundImage.image = model.background
        baseImage.image = model.base
        bottomView.backgroundColor = model.text
        if  model == .seventh {
            baseImage.contentMode = .scaleAspectFit
        } else {
            baseImage.contentMode = .scaleAspectFill
        }
    }
    
}
