//
//  DataManagementSettingsView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/05/2022.
//

import UIKit

class DataManagementSettingsView: UIView {
    
    //MARK: Properties
    let title: String
    let value: String?
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       valueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = title
        label.font = .notoSansJPRegular(size: .size14)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = value
        label.isHidden = value?.isEmpty ?? true
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .notoSansJPRegular(size: .size14)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(hexString: "#D0D0D0").withAlphaComponent(0.6)
        return view
    }()
    
    //MARK: Initializers
    init(title: String, value: String? = nil) {
        self.title = title
        self.value = value
        super.init(frame: .zero)
        prepareLayout()
    }
    
    override init(frame: CGRect) {
        title = ""
        value = ""
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 18, left: 22, bottom: 18, right: 28))
        
        addSubview(seperatorView)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            seperatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func set(_ value: String?) {
        valueLabel.text = value
    }
    
}
