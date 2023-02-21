//
//  OfficialSiteView.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/23/22.
//

import UIKit

class OfficialSiteView: UIView {
    
    //MARK: Properties
    let twitterButton = UIButton(type: .custom)
    let lineButton = UIButton(type: .custom)
    let facebookButton = UIButton(type: .custom)
    let youtubeButton = UIButton(type: .custom)
    
    weak var presenter: OfficialSiteModuleInterface?
    
    //MARK: UI Elements
    lazy var topView: UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(hexString: "#C4C4C4").withAlphaComponent(0.4)
        
        let label = UILabel()
        label.text = LocalizedKey.officialWebsite.value
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        label.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 27),
            label.centerYAnchor.constraint(equalTo: v.centerYAnchor)
        ])
        
        return v
    }()
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "公式 サイトについて"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appFont(type: .notoSansJP(.regular), size: .size15)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "ウェブサイトの説明がはいります。ウェブサイトの説明がはいります。ウェブサイトの説明がはいります。ウェブサイトの説明がはいります。ウェブサイトの説明がはいります。"
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var siteImageView: UIImageView = {
       let img = UIImageView()
        img.layer.borderWidth = 1
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var siteLabel: UILabel = {
       let label = UILabel()
        label.text = "https://brasso.com"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .appFont(type: .notoSansJP(.regular), size: .size15)
        return label
    }()
    
    lazy var snsLabel: UILabel = {
       let label = UILabel()
        label.text = "各種 SNS　ボタン"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size15)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackView: UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        twitterButton.setImage(UIImage(named: "twitter"), for: .normal)
        twitterButton.addTarget(self, action: #selector(twitterButtonTapped), for: .touchUpInside)
        
        lineButton.setImage(UIImage(named: "line"), for: .normal)
        lineButton.addTarget(self, action: #selector(lineButtonTapped), for: .touchUpInside)
        
        facebookButton.setImage(UIImage(named: "facebook"), for: .normal)
        facebookButton.addTarget(self, action: #selector(facebookButtonTapped), for: .touchUpInside)
        
        youtubeButton.setImage(UIImage(named: "insta"), for: .normal)
        youtubeButton.addTarget(self, action: #selector(youtubeButtonTapped), for: .touchUpInside)
        
        sv.addArrangedSubview(twitterButton)
        sv.addArrangedSubview(lineButton)
        sv.addArrangedSubview(facebookButton)
        sv.addArrangedSubview(youtubeButton)
        
        
        return sv
    }()
    
    lazy var footerLabel: UILabel = {
       let label = UILabel()
        label.text = "今後とも『BRASSO』を\n何卒よろしくお願いいたします。\n『BRASSO』運営チーム"
        label.font = .appFont(type: .notoSansJP(.regular), size: .size15)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: Intializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureTopView()
        configureScrollView()
        configureHeaderLabel()
        configureDescriptionLabel()
        configureSiteImageView()
        configureSiteLabel()
        configureSNSLabel()
        configureStackView()
        configureFooterLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect, presenter: OfficialSiteModuleInterface?) {
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
    
    private func configureScrollView() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureHeaderLabel() {
        scrollView.addSubview(headerLabel)
        headerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
    }
    
    private func configureDescriptionLabel() {
        scrollView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27),
            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20)
        ])
    }
    
    private func configureSiteImageView() {
        scrollView.addSubview(siteImageView)
        NSLayoutConstraint.activate([
            siteImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            siteImageView.heightAnchor.constraint(equalToConstant: 181),
            siteImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
            siteImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27)
        ])
    }
    
    private func configureSiteLabel() {
        scrollView.addSubview(siteLabel)
        NSLayoutConstraint.activate([
            siteLabel.topAnchor.constraint(equalTo: siteImageView.bottomAnchor, constant: 15),
            siteLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func configureSNSLabel() {
        scrollView.addSubview(snsLabel)
        NSLayoutConstraint.activate([
            snsLabel.topAnchor.constraint(equalTo: siteLabel.bottomAnchor, constant: 30),
            snsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    private func configureStackView() {
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: snsLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27),

        ])
    }
    
    private func configureFooterLabel() {
        scrollView.addSubview(footerLabel)
        NSLayoutConstraint.activate([
            footerLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            footerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            footerLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }
    
    //MARK: Objc Methods
    @objc private func twitterButtonTapped() {
        presenter?.twitterButtonTapped()
    }
    
    @objc private func lineButtonTapped() {
        presenter?.lineButtonTapped()
    }
    
    @objc private func facebookButtonTapped() {
        presenter?.facebookButtonTapped()
    }
    
    @objc private func youtubeButtonTapped() {
        presenter?.youtubeButtonTapped()
    }
}
