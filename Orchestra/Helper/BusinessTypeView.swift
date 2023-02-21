//
//  BusinessTypeView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//

import UIKit

class BusinessTypeView: UIView {
    
    //MARK: UI Properties
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        label.textColor = UIColor(hexString: "#757575")
        label.numberOfLines = .zero
//        label.textAlignment = .center
        return label
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
        curve = 4
        set(of: UIColor(hexString: "#757575"))
        addSubview(label)
//        label.fillSuperView(inset: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setValue(_ value: String?) {
        label.text = value
    }
    
}
