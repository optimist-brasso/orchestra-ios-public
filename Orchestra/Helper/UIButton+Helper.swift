//
//  UIButton+Helper.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 31/03/2022.
//

import Foundation
import UIKit

enum AppButtonType {
    case none
    case border
    case auth
    
}

class AppButton: UIButton {
    
    var appButtonType = AppButtonType.none {
        didSet {
            create()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        create()
    }
    
    /// Coder initializer
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        create()
    }
    
    func create() {
        switch  appButtonType {
        case .none:
            break
        case .border:
            layer.borderColor = UIColor.black.cgColor
            layer.borderWidth = 1
            layer.cornerRadius = 5
            layer.masksToBounds = true
        case .auth:
            backgroundColor = .blueButtonBackground
            layer.cornerRadius = 5
            layer.masksToBounds = true
            setTitleColor(.white, for: .normal)
        }
    }
    
}

class ImageButton: UIView {
    
    //MARK: Properties
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var textColor: UIColor? {
        didSet {
            titleLabel.textColor = textColor
        }
    }
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView,
                                                       titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView(image: image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 25).isActive = true
        image.heightAnchor.constraint(equalTo: image.widthAnchor).isActive = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 119).isActive = true
        label.font = .notoSansJPRegular(size: .size14)
        label.textAlignment = .left
        label.textColor = .border
        label.text = title
        return label
    }()
    
    //MARK: Initialiizers
    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
        super.init(frame: .zero)
        setup()
        create()
    }

     required init?(coder: NSCoder) {
         super.init(coder: coder)
         setup()
         create()
    }
    
    private func setup() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
    
    private func create() {
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
//        addSubview(imageView)
//        addSubview(titleLabel)
//
//        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
//
//            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
//            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo:trailingAnchor, constant: -10),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
//        ])
    }
    
}

class CheckButton: UIControl {
    
    private(set) lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .white
        image.contentMode = .center
        return image
    }()
    
    var changeBackground = true
    
    override var isSelected: Bool {
        didSet {
            image.image =  isSelected ? UIImage(systemName: "checkmark") : nil
            if changeBackground {
                image.backgroundColor = isSelected ? .blueButtonBackground : .clear
                layer.borderColor =  isSelected ? UIColor.blueButtonBackground.cgColor  : UIColor.black.cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        create()
    }

     required init?(coder: NSCoder) {
         super.init(coder: coder)
         create()
    }
    
    
    func create() {
        addSubview(image)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.masksToBounds = true
        clipsToBounds = true
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.topAnchor.constraint(equalTo: topAnchor),
            image.centerXAnchor.constraint(equalTo: centerXAnchor)
            //image.widthAnchor.constraint(equalToConstant: 40),
            
        ])
    }
}
