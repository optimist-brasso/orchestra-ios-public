//
//  HomeFooterView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/07/2022.
//

import UIKit

class HomeFooterView: UIView {
    
    //MARK: UI Properties
    private lazy var businessRestructuringButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 27).isActive = true
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        button.setTitle("R2 事業再構築", for: .normal)
        button.titleLabel?.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        button.setTitleColor(UIColor(hexString: "#757575"), for: .normal)
        button.set(of: UIColor(hexString: "#757575"))
        button.configuration = UIButton.Configuration.plain()
        button.configuration?.titlePadding = 12
        button.curve = 4
        return button
    }()
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        addSubview(businessRestructuringButton)
        NSLayoutConstraint.activate([
            businessRestructuringButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            businessRestructuringButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            businessRestructuringButton.heightAnchor.constraint(equalToConstant: 27)
            //businessRestructuringButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
//        businessRestructuringButton.fillSuperView(inset: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
    }
    
}
