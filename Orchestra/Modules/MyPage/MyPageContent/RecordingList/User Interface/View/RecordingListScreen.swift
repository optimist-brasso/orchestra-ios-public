//
//  RecordingListScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import UIKit

class RecordingListScreen: BaseScreen {
    
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
                                                       groupButton,
                                                       filterButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 18
        stackView.isHidden = true 
        return stackView
    }()
    
    private(set) lazy var searchBar: CustomSearchBar = {
        let searchBar = CustomSearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        searchBar.curve = 15
        searchBar.set(borderWidth: 1, of: UIColor(hexString: "#D5D5D5"))
        searchBar.placeholder = LocalizedKey.homeListingSearchPlaceholder.value
        return searchBar
    }()
    
    private lazy var groupButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.group, for: .normal)
        return button
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.filter, for: .normal)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.recordingEditingList.value
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(RecordingListTableViewCell.self)
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
