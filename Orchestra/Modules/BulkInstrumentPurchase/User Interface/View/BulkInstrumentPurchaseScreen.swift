//
//  BulkInstrumentPurchaseScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/06/2022.
//
//

import UIKit

class BulkInstrumentPurchaseScreen: BaseScreen {
    
    // MARK: Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [japaneseTitleLabel,
                                                       descriptionLabel,
                                                       contentStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 18
        return stackView
    }()
    
//    private(set) lazy var backButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
//        button.setImage(UIImage(named: "back"), for: .normal)
//        return button
//    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "English Title"
        label.numberOfLines = .zero
        label.font = .appFont(type: .notoSansJP(.regular), size: .size16)
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var japaneseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "日本語表記の楽曲名"
        label.numberOfLines = .zero
        label.font = .appFont(type: .notoSansJP(.regular), size: .size16)
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "複数MinusOneをまとめて購入できます"
        label.numberOfLines = .zero
        label.font = .appFont(type: .notoSansJP(.regular), size: .size16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tableView,
                                                       buttonView])
        stackView.axis = .vertical
        return stackView
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.registerCell(BulkInstrumentPurchaseTableViewCell.self)
        return tableView
    }()
    
    private(set) var buttonView: BulkInstrumentPurchaseButtonView = {
        let view = BulkInstrumentPurchaseButtonView()
        view.isHidden = true
        return view
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        
//        addSubview(backButton)
//        NSLayoutConstraint.activate([
//            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
//            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20)
//        ])
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
        ])
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
//        stackView.fillSuperView()
        
        NSLayoutConstraint.activate([
            japaneseTitleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        ])
    }
    
}
