//
//  ProfileScreen.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

import UIKit

class ProfileScreen: BaseScreen {
    
    //MARK: Properties
    var viewModel: ProfileViewModel? {
        didSet {
            setData()
        }
    }
    
    // MARK: UI Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleView, scrollView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#C4C4C4").withAlphaComponent(0.4)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.profile.value
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        return label
    }()
    
    private lazy var profileImageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, editButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = RoundedImageView(image: GlobalConstants.Image.profile)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 140 * (UIDevice.current.userInterfaceIdiom == .pad ? 1.5 : 1)).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(hexString: "#C4C4C4")
        return imageView
    }()
    
    private(set) lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.setImage(GlobalConstants.Image.edit, for: .normal)
        button.setTitle(LocalizedKey.edit.value, for: .normal)
        button.backgroundColor = UIColor(hexString: "#D0D0D0")
        button.titleLabel?.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        button.setTitleColor(UIColor(hexString: "#262626"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: 8)
        button.curve = 4
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [yourProfileLabel,
                                                       nameView,
                                                       genderView,
                                                       nickNameView,
                                                       musicalInstrumentView,
                                                       areaView,
                                                       ageView,
                                                       emailView,
                                                       professionView,
                                                       introductionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var yourProfileLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.yourProfile.value
        label.font = .appFont(type: .notoSansJP(.medium), size: .size14)
        label.textColor = UIColor(hexString: "#333333")
        return label
    }()
    
    private lazy var nameView: ProfileContentView = {
        let view = ProfileContentView(title: LocalizedKey.name.value)
        return view
    }()
    
    private lazy var genderView: ProfileContentView = {
        let view = ProfileContentView(title: LocalizedKey.gender.value)
        return view
    }()
    
    private lazy var nickNameView: ProfileContentView = {
        let view = ProfileContentView(title: LocalizedKey.nickname.value)
        return view
    }()
    
    private lazy var musicalInstrumentView: ProfileContentView = {
        let view = ProfileContentView(title: LocalizedKey.musicalInstrument.value)
        return view
    }()
    
    private lazy var areaView: ProfileContentView = {
        let view = ProfileContentView(title: LocalizedKey.postalCode.value)
        return view
    }()
    
    private lazy var ageView: ProfileContentView = {
        let view = ProfileContentView(title: LocalizedKey.dateOfBirth.value)
        return view
    }()
    
    private lazy var emailView: ProfileContentView = {
        let view = ProfileContentView(title: LocalizedKey.email.value)
        return view
    }()
    
    private lazy var professionView: ProfileContentView = {
        let view = ProfileContentView(title: LocalizedKey.profession.value)
        return view
    }()
    
    private lazy var introductionView: ProfileContentView = {
        let view = ProfileContentView(title: LocalizedKey.selfIntroduction.value)
        return view
    }()
    
    //MARK: Override function
    override func create() {
        super.create()
        addSubview(stackView)
        stackView.fillSuperView()
        
        scrollView.addSubview(containerView)
        containerView.fillSuperView()
        
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        titleView.addSubview(titleLabel)
        titleLabel.fillSuperView(inset: UIEdgeInsets(top: 12, left: 26, bottom: 12, right: 26))
        
        containerView.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        
        containerView.addSubview(profileImageStackView)
        NSLayoutConstraint.activate([
            profileImageStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            profileImageStackView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 27),
            editButton.widthAnchor.constraint(equalTo: profileImageView.widthAnchor)
        ])

        
        containerView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            contentStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            contentStackView.topAnchor.constraint(equalTo: profileImageStackView.bottomAnchor, constant: 40),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func setData() {
        stackView.isHidden = false
        profileImageView.showImage(with: viewModel?.image, placeholderImage: .profilePlaceholder)
        nameView.setValue(viewModel?.name)
        genderView.setValue(viewModel?.gender)
        nickNameView.setValue(viewModel?.nickname)
        musicalInstrumentView.setValue(viewModel?.musicalInstrument)
        areaView.setValue(viewModel?.postalCode)
        ageView.setValue(viewModel?.age)
        emailView.setValue(viewModel?.email)
        professionView.setValue(viewModel?.profession)
        introductionView.setValue(viewModel?.selfIntroduction)
    }
    
}
