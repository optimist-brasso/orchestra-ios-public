//
//  AppendixVideoDetailScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//
//

import UIKit

class AppendixVideoDetailScreen: BaseScreen {
    
    //MARK: Properties
    var viewModel: AppendixVideoDetailViewModel? {
        didSet {
//            buttonView.purchased = viewModel?.isBought ?? false
//            buttonView.buyButton.setTitle(viewModel?.isPartBought ?? false ? "PREMIUM映像 \(viewModel?.price ?? "") を購入する" : LocalizedKey.buyPremiumVideoBundle.value, for: .normal)
//            buttonView.seperateUnpurchaseableLabel.isHidden = viewModel?.isPartBought ?? false
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
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.registerCell(AppendixVideoDetailPlayerTableViewCell.self)
        tableView.registerCell(AppendixVideoDetailTableViewCell.self)
        tableView.registerCell(AppendixVideoDetailDescriptionTableViewCell.self)
        return tableView
    }()
    
    private(set) lazy var buttonView: AppendixVideoDetailButtonView = {
        let view = AppendixVideoDetailButtonView()
//        view.purchased = true
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
    }
    
}
