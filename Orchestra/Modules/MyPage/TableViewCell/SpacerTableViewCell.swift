//
//  SpacerTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//

import UIKit

class SpacerTableViewCell: UITableViewCell {
    
    //MARK: UI Properties
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#D0D0D0").withAlphaComponent(0.6)
        return view
    }()
    
    //MARK: Initializer
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
        contentView.addSubview(seperatorView)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            seperatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            seperatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
