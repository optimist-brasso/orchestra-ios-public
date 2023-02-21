//
//  OrchestraListingHeaderTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
import UIKit

class OrchestraListingHeaderTableViewCell: UITableViewCell {
    
    var pageOption: OrchestraType? {
        didSet {
            searchBar.placeholder = pageOption?.searchPlaceholder ?? "N/A"
        }
    }
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchBar, actionStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 26
        return stackView
    }()
    
    private(set) lazy var searchBar: CustomSearchBar = {
        let customSearchBar = CustomSearchBar()
        customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        customSearchBar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        customSearchBar.curve = 15
        customSearchBar.set(borderWidth: 1, of: UIColor(hexString: "#D5D5D5"))
        customSearchBar.placeholder = pageOption?.searchPlaceholder ?? "N/A"
        return customSearchBar
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupButton, filterButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.isHidden = true 
        return stackView
    }()
    
    private lazy var groupButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 17).isActive = true
        button.setImage(GlobalConstants.Image.group, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 17).isActive = true
        button.setImage(GlobalConstants.Image.filter, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    //MARK: Initializers
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
        contentView.backgroundColor = .white
        
        contentView.addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 9, left: 20, bottom: 4, right: 25))
    }
    
}
