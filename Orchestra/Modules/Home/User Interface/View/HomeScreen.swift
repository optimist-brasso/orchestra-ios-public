//
//  HomeScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//
//

import UIKit

class HomeScreen: BaseScreen {
    
    // MARK: Properties
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerCell(PageOptionTableViewCell.self)
        tableView.registerCell(HomeBannerTableViewCell.self)
        tableView.registerCell(HomeHeaderTableViewCell.self)
        tableView.registerCell(HomeRecommendationTableViewCell.self)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private(set) lazy var pointView: PointFloatingView = {
        let tableView = PointFloatingView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    
    //MARK: Override function
    override func create() {
        super.create()
        
        addSubview(tableView)
        addSubview(pointView)
        tableView.fillSuperView()
        
        NSLayoutConstraint.activate([
            pointView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 4),
            pointView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            pointView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
}
