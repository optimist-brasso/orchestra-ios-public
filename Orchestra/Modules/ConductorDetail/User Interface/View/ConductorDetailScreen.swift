//
//  ConductorDetailScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//
//

import UIKit

class ConductorDetailScreen: BaseScreen {
    
    // MARK: Properties
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(ConductorDetailPlayerTableViewCell.self)
        tableView.registerCell(ConductorDetailTitleTableView.self)
        tableView.registerCell(ConductorDetailTableViewCell.self)
        tableView.separatorStyle = .none
        return tableView
    }()
    
//    private(set) lazy var backButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
//        button.setImage(UIImage(named: "back"), for: .normal)
//        return button
//    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        addSubview(tableView)
        tableView.fillSuperView()
//        NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
        
//        addSubview(backButton)
//        NSLayoutConstraint.activate([
//            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
//            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 14)
//        ])
    }
    
}
