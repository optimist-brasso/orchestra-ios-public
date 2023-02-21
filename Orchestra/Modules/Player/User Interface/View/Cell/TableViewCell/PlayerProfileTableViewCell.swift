//
//  PlayerProfileTableViewCell.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//

import UIKit

class PlayerProfileTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var viewModel: PlayerViewModel? {
        didSet {
            setData()
        }
    }
    var openWebsite: ((String?) -> ())?
    
    //MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [detailStackView,
                                                       profileLinkStackView,
                                                       socialContactStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 25
        return stackView
    }()
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoStackView,
                                                       messageStackView])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [birthdayView,
                                                       bloodGroupView,
                                                       birthPlaceView,
                                                       manufacturerView])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var birthdayView: PlayerInfoView = {
        let view = PlayerInfoView(title: "\(LocalizedKey.birthday.value)：")
        return view
    }()
    
    private lazy var bloodGroupView: PlayerInfoView = {
        let view = PlayerInfoView(title: "\(LocalizedKey.bloodGroup.value)：")
        return view
    }()
    
    private lazy var birthPlaceView: PlayerInfoView = {
        let view = PlayerInfoView(title: "\(LocalizedKey.birthPlace.value)：")
        return view
    }()
    
    private lazy var manufacturerView: PlayerInfoView = {
        let view = PlayerInfoView(title: "\(LocalizedKey.manufacturer.value)：")
        return view
    }()
    
    private lazy var messageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [messageTitleLabel,
                                                       messageLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var messageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.playerMessage.value
        label.font = .appFont(type: .notoSansJP(.light), size: .size16)
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = """
                奏者からユーザーに向けたメッセージが入ります。奏者からユーザーに向けたメッセージが入ります。奏者からユーザーに向けたメッセージが入ります。奏者からユーザーに向けたメッセージが入ります。奏者からユーザーに向けたメッセージが入ります。奏者からユーザーに向けたメッセージが入ります。
        """
        label.font = .appFont(type: .notoSansJP(.light), size: .size16)
        label.numberOfLines = .zero
        label.textAlignment = .justified
        return label
    }()
    
    private lazy var profileLinkStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileLinkTitleLabel,
                                                       profileLinkLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var profileLinkTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.profileLink.value
        label.font = .appFont(type: .notoSansJP(.light), size: .size16)
        return label
    }()
    
    private lazy var profileLinkLabel: UILabel = {
        let label = UILabel()
        label.text = "https://www.xxxxxxxx.com"
        label.font = .appFont(type: .notoSansJP(.light), size: .size14)
        label.isUserInteractionEnabled = true
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var socialContactStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [twitterView,
                                                       instagramView,
                                                       facebookView,
                                                       youtubeView])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var twitterView: PlayerSocialInfoView = {
        let view = PlayerSocialInfoView(title: "twitter")
        return view
    }()
    
    private lazy var instagramView: PlayerSocialInfoView = {
        let view = PlayerSocialInfoView(title: "instagram")
        return view
    }()
    
    private lazy var facebookView: PlayerSocialInfoView = {
        let view = PlayerSocialInfoView(title: "facebook")
        return view
    }()
    
    private lazy var youtubeView: PlayerSocialInfoView = {
        let view = PlayerSocialInfoView(title: "youtube")
        return view
    }()
    
    
    //MARK: Initilaizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        prepareLayout()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -46)
        ])
    }
    
    private func setupGesture() {
        [twitterView.valueLabel,
         instagramView.valueLabel,
         facebookView.valueLabel,
         youtubeView.valueLabel,
         profileLinkLabel].forEach({
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedLabel(_:))))
        })
    }
    
    private func setData() {
        birthdayView.setValue(viewModel?.birthday)
        bloodGroupView.setValue(viewModel?.bloodGroup)
        birthPlaceView.setValue(viewModel?.birthplace)
        manufacturerView.setValue(viewModel?.manufacturer)
        twitterView.setValueAsLink(viewModel?.twitter)
        instagramView.setValueAsLink(viewModel?.instagram)
        facebookView.setValueAsLink(viewModel?.facebook)
        youtubeView.setValueAsLink(viewModel?.youtube)
        messageLabel.text = viewModel?.message
        messageStackView.isHidden = viewModel?.message?.isEmpty ?? true
//        profileLinkLabel.text = viewModel?.profileLink
        let profileLink = viewModel?.profileLink ?? ""
        let profileLinkAttributedString = NSMutableAttributedString(string: profileLink)
        let linkRange = NSRange(location: .zero, length: profileLink.count)
        profileLinkAttributedString.addAttribute(.link, value: profileLink, range: linkRange)
        profileLinkLabel.attributedText = profileLinkAttributedString
        profileLinkStackView.isHidden = viewModel?.profileLink?.isEmpty ?? true
    }
    
    @objc private func didTappedLabel(_ gestureRecognizer: UITapGestureRecognizer) {
        if let label = gestureRecognizer.view as? UILabel {
            openWebsite?(label.text)
        }
    }
    
}
