//
//  SettingsView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/01/2023.
//

import UIKit

class SettingsView: UIView {
    
    //MARK: Properties
    let title: String
    var detail: String? {
        didSet {
            descriptionLabel.text = detail
            descriptionLabel.isHidden = detail?.isEmpty ?? true
        }
    }
    let allowsNavigation: Bool
    let includeSwitch: Bool
    var onTap: (() -> Void)?
    var switchEnabled: ((Bool) -> Void)?
    var enabled: Bool? {
        didSet {
            settingsSwitch.isOn = enabled ?? false
        }
    }
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label,
                                                       descriptionLabel,
                                                       arrowImageView,
                                                       settingsSwitch])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = title
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = detail
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        label.isHidden = detail?.isEmpty ?? true
        label.textAlignment = .right
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: GlobalConstants.Image.rightArrow)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = !allowsNavigation
        return imageView
    }()
    
    private(set) lazy var settingsSwitch: UISwitch = {
        let onOffSwitch = UISwitch()
        onOffSwitch.isHidden = !includeSwitch
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
    init(title: String, detail: String? = nil, allowsNavigation: Bool = true, includeSwitch: Bool = false) {
        self.title = title
        self.detail = detail
        self.allowsNavigation = allowsNavigation
        self.includeSwitch = includeSwitch
        super.init(frame: .zero)
        prepareLayout()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 21, left: 27, bottom: 22, right: 32))
        
        addSubview(seperatorView)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            seperatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    @objc private func viewTapped() {
        onTap?()
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        switchEnabled?(sender.isOn)
    }

}
