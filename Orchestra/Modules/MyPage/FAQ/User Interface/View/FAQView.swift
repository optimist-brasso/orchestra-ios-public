//
//  FAQView.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/21/22.
//

import UIKit

class FAQView: UIView {
    
    //MARK: Properties
    weak var presenter: FAQModuleInterface?
    
    //MARK: UI Elements
    lazy var topView: UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(hexString: "#C4C4C4").withAlphaComponent(0.4)
        
        let label = UILabel()
        label.text = LocalizedKey.faq.value
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
        label.text = "FAQ（よくあるご質問）・お問い合わせ"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appFont(type: .notoSansJP(.regular), size: .size15)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "よくあるご質問をまとめております。各種ボタンよりご確認くださいませ。"
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var frequentAskQButton: UIButton = {
       let btn = UIButton()
        btn.setTitle(LocalizedKey.clickForFAQ.value, for: .normal)
        addSimilarProperties(to: btn)
        btn.addTarget(self, action: #selector(frequentAskButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var contactUsButton: UIButton = {
       let btn = UIButton()
        btn.setTitle(LocalizedKey.clickForContactUs.value, for: .normal)
        addSimilarProperties(to: btn)
        btn.addTarget(self, action: #selector(contactUsButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: Intialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTopView()
        configureHeaderLabel()
        configureDescriptionLabel()
        configureFrequentAskQButton()
        configureContactUsButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, presenter: FAQModuleInterface?) {
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
    
    private func configureFrequentAskQButton() {
        addSubview(frequentAskQButton)
        NSLayoutConstraint.activate([
            frequentAskQButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
            frequentAskQButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27),
            frequentAskQButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            frequentAskQButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureContactUsButton() {
        addSubview(contactUsButton)
        NSLayoutConstraint.activate([
            contactUsButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
            contactUsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27),
            contactUsButton.topAnchor.constraint(equalTo: frequentAskQButton.bottomAnchor, constant: 15),
            contactUsButton.heightAnchor.constraint(equalToConstant: 50)
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
    
    //MARK: Objc Methdods
    @objc func frequentAskButtonTapped() {
        presenter?.frequentAskButtonTapped()
    }
    
    @objc private func contactUsButtonTapped() {
        presenter?.contactUsButtonTapped()
    }
    
}
