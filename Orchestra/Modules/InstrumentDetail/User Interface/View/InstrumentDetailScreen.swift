//
//  InstrumentDetailScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 6/13/22.
//
//

import UIKit

class InstrumentDetailScreen: BaseScreen {
    
    //MARK: Properties
    var viewModel: InstrumentDetailViewModel? {
        didSet {
            buttonView.buyButton.isHidden = viewModel?.isBought ?? false
//            buttonView.buyButton.setTitle(viewModel?.isBought ?? false ? LocalizedKey.rec.value : LocalizedKey.buyPart(viewModel?.price ?? "").value, for: .normal)
//            buttonView.premiumAppendixButton.isHidden = !(viewModel?.isPremiumBought ?? false)
//            buttonView.premiumButton.isHidden = viewModel?.isPremiumBought ?? true
        }
    }
    
    // MARK: UI Properties
    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            //            playerView,
            tableView,
            buttonView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.isHidden = true
        return stackView
    }()
    
//    private(set) lazy var backButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
//        button.setImage(.back, for: .normal)
//        return button
//    }()
    
    private(set) lazy var playerView: InstrumentDetailPlayerView = {
        let view = InstrumentDetailPlayerView()
        return view
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.registerCell(InstrumentDetailTableViewCell.self)
        tableView.registerCell(InstrumentDetailDescriptionTableViewCell.self)
        tableView.registerCell(InstrumentDetailPlayerTableViewCell.self)
//        tableView.registerCell(InstrumentDetailButtonTableViewCell.self)
        return tableView
    }()
    
    private(set) lazy var buttonView: InstrumentDetailButtonView = {
        let view = InstrumentDetailButtonView()
        return view
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
//        addSubview(backButton)
//        NSLayoutConstraint.activate([
//            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
//            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 14)
//        ])

//        stackView.fillSuperView()
    }
    
}
