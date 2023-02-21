//
//  PlayerDetailTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//

import UIKit

class PlayerDetailTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: PlayerViewModel? {
        didSet {
            setData()
        }
    }
    var favourite: (() -> Void)?
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [detailStackView,
                                                       descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel,
                                                       separatorView,
                                                       instrumentLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "熊代 祐子"
        label.font = .appFont(type: .notoSansJP(.light), size: .size36)
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var separatorView: PlayerSeperatorView = {
        let view = PlayerSeperatorView()
        return view
    }()
    
    private lazy var instrumentLabel: UILabel = {
        let label = UILabel()
        label.text = "B♭トランペット"
        label.font = .appFont(type: .notoSansJP(.light), size: .size20)
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "シエナ・ウインド・オーケストラ所属"
        label.numberOfLines = .zero
        label.font = .appFont(type: .notoSansJP(.light), size: .size20)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = FavouriteButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
//        button.setImage(GlobalConstants.Image.TabBar.favourite, for: .normal)
        button.tintColor = UIColor(hexString: "#6A6969")
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
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
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -46)
        ])
        
        contentView.addSubview(favouriteButton)
        NSLayoutConstraint.activate([
            favouriteButton.widthAnchor.constraint(equalToConstant: 20),
            favouriteButton.heightAnchor.constraint(equalTo: favouriteButton.widthAnchor),
            favouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favouriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        ])
    }
    
    private func setData() {
        nameLabel.text = viewModel?.name
        instrumentLabel.text = viewModel?.instrument
        instrumentLabel.isHidden = viewModel?.instrument?.isEmpty ?? true
        descriptionLabel.text = viewModel?.band
        separatorView.isHidden = viewModel?.instrument?.isEmpty ?? true && viewModel?.band?.isEmpty ?? true
        descriptionLabel.isHidden = viewModel?.band?.isEmpty ?? true
        favouriteButton.isSelected = viewModel?.isFavourite ?? false
    }
    
   @objc  private func buttonTapped(_ sender: UIButton) {
       switch sender {
       case favouriteButton:
           favourite?()
       default: break
       }
    }
    
}
