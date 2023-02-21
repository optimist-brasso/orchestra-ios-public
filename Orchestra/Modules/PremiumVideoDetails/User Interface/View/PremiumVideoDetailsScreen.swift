//
//  PremiumVideoDetailsScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import UIKit

class PremiumVideoDetailsScreen: BaseScreen {
    
    //MARK: Properties
    var viewModel: PremiumVideoDetailsViewModel? {
        didSet {
//            buttonView.purchased = viewModel?.isBought ?? false
            buttonView.buyButton.isHidden = viewModel?.isBought ?? false
            buttonView.infoLabel.isHidden = viewModel?.isPartBought ?? false
//            if  (viewModel?.isBought ?? false) {
//                buttonView.buyButton.setTitle(LocalizedKey.rec.value, for: .normal)
//                return
//            }
            buttonView.buyButton.setTitle(viewModel?.isPartBought ?? false ? LocalizedKey.buyPremiumVideo.value : LocalizedKey.buyPremiumVideoBundle.value, for: .normal)
        }
    }
    
    // MARK: UI Properties
    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tableView,
                                                       buttonView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
        stackView.axis = .vertical
        stackView.isHidden = true
        return stackView
    }()
    
    private(set) lazy var playerView: PremiumVideoDetailsPlayerView = {
        let view = PremiumVideoDetailsPlayerView()
        return view
    }()
    
//    private(set) lazy var backButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
//        button.setImage(.back, for: .normal)
//        return button
//    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.registerCell(PremiumVideoDetailsTableViewCell.self)
        tableView.registerCell(PremiumVideoDetailsDescriptionTableViewCell.self)
        tableView.registerCell(PremiumVideoDetailsPurchaseTableViewCell.self)
        tableView.registerCell(PremiumVideoDetailsPlayerTableViewCell.self)
        return tableView
    }()
    
    private(set) lazy var buttonView: PremiumVideoDetailsButtonView = {
        let view = PremiumVideoDetailsButtonView()
        view.purchased = false
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
    }
    
}
