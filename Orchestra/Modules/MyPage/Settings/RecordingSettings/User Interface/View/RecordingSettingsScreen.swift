//
//  RecordingSettingsScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//
//

import UIKit

class RecordingSettingsScreen: BaseScreen {
    
    // MARK: Properties
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerCell(MyPageHeaderTableViewCell.self)
        tableView.registerCell(RecordingSettingsTableViewCell.self)
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
