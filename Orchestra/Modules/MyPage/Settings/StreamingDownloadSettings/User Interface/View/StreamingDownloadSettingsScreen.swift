//
//  StreamingDownloadSettingsScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit

class StreamingDownloadSettingsScreen: BaseScreen {
    
    // MARK: Properties
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerCell(MyPageHeaderTableViewCell.self)
        tableView.registerCell(MyPageTableViewCell.self)
        tableView.registerCell(SwitchTableViewCell.self)
        tableView.registerCell(SpacerTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        return tableView
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        
        addSubview(tableView)
        tableView.fillSuperView()
    }
    
}
