//
//  SwitchTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var title: String? {
        didSet {
            label.text = title
        }
    }
    var switchEnabled: ((Bool) -> Void)?
    var enabled: Bool? {
        didSet {
            settingsSwitch.isOn = enabled ?? false
        }
    }
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label,
                                                      settingsSwitch])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
//        label.numberOfLines = .zero
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private(set) lazy var settingsSwitch: UISwitch = {
        let onOffSwitch = UISwitch()
//        onOffSwitch.translatesAutoresizingMaskIntoConstraints = false
        onOffSwitch.onTintColor = UIColor(hexString: "#0D6483")
        onOffSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return onOffSwitch
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#D0D0D0").withAlphaComponent(0.6)
        return view
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
        stackView.fillSuperView(inset: UIEdgeInsets(top: 21, left: 27, bottom: 22, right: 32))
        
        contentView.addSubview(seperatorView)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            seperatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
//        contentView.addSubview(settingsSwitch)
//        NSLayoutConstraint.activate([
//            seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
//            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        switchEnabled?(sender.isOn)
    }

}
