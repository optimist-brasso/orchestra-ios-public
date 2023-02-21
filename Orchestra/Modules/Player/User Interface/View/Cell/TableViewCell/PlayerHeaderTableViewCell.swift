//
//  PlayerHeaderTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//

import UIKit

class PlayerHeaderTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var title: String? {
        didSet {
            label.text = title
        }
    }
    
    //MARK: UI Properties
    private lazy var topSeperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#B2964E")
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topSeperatorView, label, bottomSeperatorView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 11
        return stackView
    }()
    
    private lazy var bottomSeperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#B2964E")
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .appFont(type: .notoSansJP(.light), size: .size16)
        label.textAlignment = .center
        return label
    }()
    
    //MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        prepareLayout()
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        contentView.addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: .zero, left: 14, bottom: .zero, right: 14))
    }
    
}
