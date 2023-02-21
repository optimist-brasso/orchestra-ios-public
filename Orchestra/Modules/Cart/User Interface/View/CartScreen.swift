//
//  CartScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/05/2022.
//
//

import UIKit

class CartScreen: BaseScreen {
    
//     MARK: Properties
    private lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 43).isActive = true
        view.backgroundColor = UIColor(hexString: "#C4C4C4").withAlphaComponent(0.4)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.cart.value
        label.font = .notoSansJPRegular(size: .size14)
        return label
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupButton,
                                                       filterButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.isHidden = true 
        return stackView
    }()
    
    private lazy var groupButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.group, for: .normal)
        return button
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(GlobalConstants.Image.filter, for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tableView,
                                                       buyView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = .zero
        return stackView
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.registerCell(CartTableViewCell.self)
        return tableView
    }()
    
    private(set) lazy var buyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 98).isActive = true
        view.isHidden = true
        return view
    }()
    
    private lazy var buySeperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#D8D8D8")
        return view
    }()
    
    private(set) lazy var buyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizedKey.buy.value, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size14)
        button.backgroundColor = UIColor(hexString: "#0D6483")
        button.curve = 8
        return button
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        
        addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        titleView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
        ])
        
        addSubview(buttonStackView)
        NSLayoutConstraint.activate([
//            buttonStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 22),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            buttonStackView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 22)
        ])
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 21),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
//            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
//        addSubview(buyView)
//        NSLayoutConstraint.activate([
//            buyView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            buyView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            buyView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
//            buyView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
//        ])
        
        buyView.addSubview(buySeperatorView)
        NSLayoutConstraint.activate([
            buySeperatorView.leadingAnchor.constraint(equalTo: buyView.leadingAnchor),
            buySeperatorView.centerXAnchor.constraint(equalTo: buyView.centerXAnchor),
            buySeperatorView.topAnchor.constraint(equalTo: buyView.topAnchor)
        ])
        
        buyView.addSubview(buyButton)
        NSLayoutConstraint.activate([
            buyButton.leadingAnchor.constraint(equalTo: buyView.leadingAnchor, constant: 69),
            buyButton.centerXAnchor.constraint(equalTo: buyView.centerXAnchor),
            buyButton.centerYAnchor.constraint(equalTo: buyView.centerYAnchor)
        ])
    }
    
}
