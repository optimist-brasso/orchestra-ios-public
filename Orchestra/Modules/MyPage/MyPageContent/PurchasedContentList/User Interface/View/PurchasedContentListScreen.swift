//
//  PurchasedContentListScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit

class PurchasedContentListScreen: BaseScreen {
    
    // MARK: Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleContainerView,
                                                       searchContainerView,
                                                       tableView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#C4C4C4").withAlphaComponent(0.4)
        return view
    }()
    
    private lazy var searchContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var searchStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchBar,
                                                       filterButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 59
        return stackView
    }()
    
    private(set) lazy var searchBar: CustomSearchBar = {
        let customSearchBar = CustomSearchBar()
        customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        customSearchBar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        customSearchBar.curve = 15
        customSearchBar.set(borderWidth: 1, of: UIColor(hexString: "#D5D5D5"))
        customSearchBar.placeholder = LocalizedKey.homeListingSearchPlaceholder.value
        return customSearchBar
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.filter, for: .normal)
        button.isHidden = true 
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.purchasedListContent.value
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(PurchasedContentListTableViewCell.self)
        tableView.registerHeader(PurchaseHeader.self)
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        return tableView
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        
        searchContainerView.addSubview(searchStackView)
        searchStackView.fillSuperView(inset: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 25))
        
        addSubview(stackView)
        stackView.fillSuperView()
        
        titleContainerView.addSubview(titleLabel)
        titleLabel.fillSuperView(inset: UIEdgeInsets(top: 12, left: 28, bottom: 12, right: 28))
    }
    
}
