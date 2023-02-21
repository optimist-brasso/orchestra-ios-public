//
//  OpinionRequestView.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/22/22.
//

import UIKit

class OpinionRequestView: UIView {
    
    //MARK: Properties
    weak var presenter: OpinionRequestModuleInterface?
    
    //MARK: UI Elements
    lazy var topView: UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(hexString: "#C4C4C4").withAlphaComponent(0.4)
        
        let label = UILabel()
        label.text = LocalizedKey.opinionRequest.value
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        label.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 27),
            label.centerYAnchor.constraint(equalTo: v.centerYAnchor)
        ])
        
        return v
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "ご意見・ご要望"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appFont(type: .notoSansJP(.regular), size: .size15)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "ご意見・ご要望は、大変お手数ですが下記よりご連絡くださいませ。"
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var requestButton: UIButton = {
       let btn = UIButton()
        btn.setTitle(LocalizedKey.opinionRequestHere.value, for: .normal)
        addSimilarProperties(to: btn)
        btn.addTarget(self, action: #selector(requestButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: Intialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTopView()
        configureHeaderLabel()
        configureDescriptionLabel()
        configureRequestButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, presenter: OpinionRequestModuleInterface?) {
        self.init(frame: frame)
        self.presenter = presenter
    }
    
    //MARK: UI Configuration
    private func configureTopView() {
        addSubview(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 43)
        ])
    }
    
    private func configureHeaderLabel() {
        addSubview(headerLabel)
        headerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20).isActive = true
    }
    
    private func configureDescriptionLabel() {
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27),
            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20)
        ])
    }
    
    private func configureRequestButton() {
        addSubview(requestButton)
        NSLayoutConstraint.activate([
            requestButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
            requestButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27),
            requestButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            requestButton.heightAnchor.constraint(equalToConstant: 50)
        ])

    }
    
    //MARK: Private Methods
    private func addSimilarProperties(to btn: UIButton) {
        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 1
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .appFont(type: .notoSansJP(AppFontWeight.regular), size: .size15)
    }
    
    //MARK: Objc Methods
    @objc private func requestButtonTapped() {
        presenter?.requestButtonTapped()
    }
}
