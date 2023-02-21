//
//  SettingsScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit

class SettingsScreen: BaseScreen {
    
    // MARK: Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerView,
                                                       streamingDownloadView,
                                                       dataManagementView,
                                                       pushNotificationView,
                                                       appVersionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var headerView: UIView = {
        let cell: MyPageHeaderTableViewCell = tableView.dequeue(cellForRowAt: IndexPath(row: .zero, section: .zero))
//        cell.translatesAutoresizingMaskIntoConstraints = false
//        cell.heightAnchor.constraint(equalToConstant: <#T##CGFloat#>)
        cell.title = LocalizedKey.settings.value
        return cell.contentView
    }()
    
    private(set) lazy var streamingDownloadView: SettingsView = {
        let view = SettingsView(title: LocalizedKey.stramingDownload.value)
        return view
    }()
    
    private(set) lazy var dataManagementView: SettingsView = {
        let view = SettingsView(title: LocalizedKey.dataManagement.value)
        return view
    }()
    
    private(set) lazy var pushNotificationView: SettingsView = {
        let view = SettingsView(title: LocalizedKey.pushNotification.value, allowsNavigation: false, includeSwitch: true)
        return view
    }()
    
    private(set) lazy var appVersionView: SettingsView = {
        let view = SettingsView(title: LocalizedKey.appVersionInformation.value, allowsNavigation: false)
        return view
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerCell(MyPageHeaderTableViewCell.self)
        tableView.registerCell(MyPageTableViewCell.self)
        tableView.registerCell(SwitchTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        return tableView
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
//        addSubview(tableView)
//        tableView.fillSuperView()
    }
    
}
