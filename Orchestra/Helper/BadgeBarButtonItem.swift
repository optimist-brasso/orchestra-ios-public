//
//  BadgeBarButtonItem.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 16/05/2022.
//

import UIKit.UIBarButtonItem

class BadgeBarButtonItem: UIBarButtonItem {
    
    @IBInspectable
    public var badgeNumber: Int = .zero {
        didSet {
            labelContainerView.isHidden = badgeNumber <= .zero
            if badgeNumber < 99 {
                label.text = "\(badgeNumber)"
                return
            }
            label.text = "99+"
        }
    }
    
    private lazy var labelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        view.widthAnchor.constraint(equalToConstant: 16).isActive = true
        view.backgroundColor = .white
        view.curve = 8
        view.isHidden = true
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(badgeNumber)"
        label.textAlignment = .center
        label.font = .notoSansJPRegular(size: .size14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    convenience init(image: UIImage?, target: Any?, action: Selector, indicatorColor: UIColor = .white) {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: button)
        let labelContainerViewTapGesture = UITapGestureRecognizer(target: target, action: action)
        labelContainerView.addGestureRecognizer(labelContainerViewTapGesture)
        labelContainerView.backgroundColor = indicatorColor
        label.textColor = indicatorColor == .white ? .black : .white
        setupView()
    }
    
    private func setupView() {
        guard let view = self.customView else {return}
        
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(labelContainerView)
        labelContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 9).isActive = true
        labelContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -9).isActive = true
        
        labelContainerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor, constant: 2),
            label.centerXAnchor.constraint(equalTo: labelContainerView.centerXAnchor),
            label.topAnchor.constraint(equalTo: labelContainerView.topAnchor),
            label.centerYAnchor.constraint(equalTo: labelContainerView.centerYAnchor)
        ])
    }
    
}
