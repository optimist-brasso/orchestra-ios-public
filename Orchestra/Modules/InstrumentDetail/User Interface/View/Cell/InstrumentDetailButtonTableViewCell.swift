//
//  InstrumentDetailButtonTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 6/13/22.
//

import UIKit

class InstrumentDetailButtonTableViewCell: UITableViewCell {
    
    //MARK: UI Properties
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#6A6A6A")
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buyButton,
                                                       premiumButton,
                                                       buyBundleButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private(set) lazy var buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.buyPart("¥200").value, for: .normal)
        button.backgroundColor = .black
        button.curve = 8
        return button
    }()
    
    private(set) lazy var premiumButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.clickForPremiumVideo.value, for: .normal)
        button.backgroundColor = UIColor(hexString: "#B2964E")
        button.curve = 8
        return button
    }()
    
    private(set) lazy var buyBundleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .notoSansJPRegular(size: .size18)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(LocalizedKey.buyBundle.value, for: .normal)
        button.backgroundColor = .black
        button.curve = 8
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
        contentView.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        contentView.addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 30, left: 32, bottom: 30, right: 32))
    }
    
}
