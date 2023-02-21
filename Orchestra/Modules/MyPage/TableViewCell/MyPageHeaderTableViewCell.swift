//
//  MyPageHeaderTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//

import UIKit

class MyPageHeaderTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var title: String? {
        didSet {
            label.text = title
        }
    }
    
    //MARK: UI Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#C4C4C4").withAlphaComponent(0.4)
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    //MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.fillSuperView()
        
        containerView.addSubview(label)
        label.fillSuperView(inset: UIEdgeInsets(top: 12, left: 28, bottom: 12, right: 28))
    }

}
