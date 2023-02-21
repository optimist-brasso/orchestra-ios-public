//
//  BuyPointScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/09/2022.
//
//

import UIKit

class BuyPointScreen: BaseScreen {
    
    // MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tableView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
//    private lazy var titleContainerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(hexString: "#C4C4C4").withAlphaComponent(0.4)
//        return view
//    }()
//
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.points.value
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.sectionHeaderTopPadding = 0 
        tableView.registerCell(BuyPointTableViewCell.self)
        tableView.registerCell(PointCell.self)
        tableView.registerHeader(PointHeader.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .init(hexString: "#F5F5F5")
        return tableView
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        addSubview(stackView)
        stackView.fillSuperView()
        
        //titleContainerView.addSubview(titleLabel)
        //titleLabel.fillSuperView(inset: UIEdgeInsets(top: 12, left: 28, bottom: 12, right: 28))
    }
    
}
