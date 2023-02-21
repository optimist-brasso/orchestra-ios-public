//
//  PlayerScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//
//

import UIKit

class PlayerScreen: BaseScreen {
    
    // MARK: Properties
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.registerCell(PlayerImageTableViewCell.self)
        tableView.registerCell(PlayerDetailTableViewCell.self)
        tableView.registerCell(PlayerProfileTableViewCell.self)
        tableView.registerCell(PlayerPerformanceTableViewCell.self)
        tableView.registerCell(PlayerHeaderTableViewCell.self)
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
        
//        addSubview(backButton)
//        NSLayoutConstraint.activate([
//            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
//            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12)
//        ])
    }
    
}
