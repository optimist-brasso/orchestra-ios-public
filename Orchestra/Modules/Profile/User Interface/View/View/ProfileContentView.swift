//
//  ProfileContentView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//

import UIKit

class ProfileContentView: UIView {
    
    let title: String
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true
        label.text = title
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        label.textColor = UIColor(hexString: "#A8A8A8")
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.text = "フルート"
        label.font = .appFont(type: .notoSansJP(.light), size: .size14)
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
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        prepareLayout()
    }
    
    override init(frame: CGRect) {
        title = ""
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 20, left: .zero, bottom: 21, right: .zero))
        
        addSubview(seperatorView)
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            seperatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setValue(_ value: String?) {
        valueLabel.text = value
        isHidden = value?.isEmpty ?? true
    }
    
}
