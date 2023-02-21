//
//  EditProfileScreen.swift
//  Orchestra
//
//  Created by manjil on 04/04/2022.
//

import UIKit

class EditProfileScreen: CancelScreen {
    
    private(set) lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private(set) lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = LocalizedKey.registerAnAccount.value
        label.textColor = .blueButtonBackground
        label.font = .notoSansJPBold(size: .size16)
        label.accessibilityIdentifier = "title"
        return label
    }()
    
    private(set) lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 70
        image.layer.masksToBounds = true
        image.image = .profilePlaceholder
        image.contentMode = .scaleAspectFill
        return image
    }()
    
//    lazy var profileDelButton: UIButton = {
//       let btn = UIButton()
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        let img = UIImage(systemName: "xmark.bin")?.withRenderingMode(.alwaysTemplate)
//        btn.setImage(img, for: .normal)
//        btn.tintColor = .red
//        return btn
//    }()
    
    private lazy var imageButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [uploadIconButton,
                                                       removeImageButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        return stackView
    }()
    
    private(set) lazy var uploadIconButton: AppButton = {
        let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 142).isActive = true
        button.appButtonType = .auth
        button.backgroundColor = .blackBackground
        button.setAttributedTitle(LocalizedKey.selectIcon.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size14)]), for: .normal)
        return button
    }()
    
    private(set) lazy var removeImageButton: AppButton = {
        let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 142).isActive = true
        button.appButtonType = .auth
        button.backgroundColor = .blackBackground
        button.setAttributedTitle(LocalizedKey.removeImage.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size14)]), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private(set) lazy var fullName: CustomText = {
        let view = CustomText()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text = LocalizedKey.fullName.value
        view.textfield.attributedPlaceholder = LocalizedKey.pleaseEnterYourName.value.placeholder
        return view
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.gender.value
        label.textColor = .black
        label.accessibilityIdentifier = "genderLable"
        label.font = .appFont(type: .system(.regular), size: .size13)
        return label
    }()
    
    private lazy var secureGenderInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.informationNotPublish.value
        label.accessibilityIdentifier = "scecureGender"
        label.textColor = .black
        label.font = .notoSansJPLight(size: .size12)
        return label
    }()
    
    private lazy var requiredGenderInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.requiredString.value
        label.textColor = .red
        label.accessibilityIdentifier = "rqurireGender"
        label.font = .notoSansJPRegular(size: .size12)
        return label
    }()
    
    private lazy var genderStack: UIStackView =  {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private(set) lazy var maleSelect: SelectGender = {
        let view = SelectGender()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.label.text = LocalizedKey.male.value
        view.tag = GenderType.male.rawValue
        view.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        return view
    }()
    
    private(set) lazy var femaleSelect: SelectGender = {
        let view = SelectGender()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.label.text = LocalizedKey.female.value
        view.tag = GenderType.female.rawValue
        view.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        return view
    }()
    
    private(set) lazy var otherSelect: SelectGender = {
        let view = SelectGender()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.label.text = LocalizedKey.addGender.value
        view.tag = GenderType.addOther.rawValue
        view.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var genderSelectionStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 12
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var genderOtherStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 32
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
  
    private(set) lazy var otherGenderText: Textfield = {
        let text = Textfield()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .textBackground
        text.set(of: UIColor(hexString: "E0E0E0"))
        return text
    }()
    
    private(set) lazy var genderSaveButton: AppButton = {
        let button = AppButton()
        button.appButtonType = .auth
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizedKey.toSave.value, for: .normal)
        button.backgroundColor = .blackBackground
        return button
    }()
    
    private(set) lazy var nickName: CustomText = {
        let view = CustomText()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text = LocalizedKey.nicknameFullCharacterOrLess.value
        view.textfield.attributedPlaceholder = LocalizedKey.pleaseEnterYourNickname.value.placeholder
        view.secureInfo.isHidden = true
        view.secureInfo.text = ""
        return view
    }()
    
    private(set) lazy var instrumentName: CustomText = {
        let view = CustomText()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text = LocalizedKey.musicalInstruments.value
        view.secureInfo.isHidden = true
        view.secureInfo.text = ""
        view.textfield.attributedPlaceholder = LocalizedKey.pleaseEnterTheInstrumentName.value.placeholder
        return view
    }()
    
    private(set) lazy var postal: CustomText = {
        let view = CustomText()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text = LocalizedKey.postalCode.value
        view.secureInfo.text = "都道府県が公開されます"
        view.textfield.attributedPlaceholder = LocalizedKey.pleaseEnterYourZipCode.value.placeholder
        view.textfield.keyboardType = .numberPad
        return view
    }()
    
    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.dateOfBirth.value
        label.textColor = .black
        label.font = .appFont(type: .system(.regular), size: .size13)
        label.accessibilityIdentifier = "age"
        return label
    }()
    
    private lazy var requiredAgeInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.requiredString.value
        label.textColor = .red
        label.font = .notoSansJPRegular(size: .size12)
        label.accessibilityIdentifier = "ageRequired"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var ageStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 16
        return stack
    }()
    private(set) lazy var yearText: Textfield = {
        let text = Textfield()
        text.rightImage = .rightArrow
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .textBackground
        text.layer.borderColor = UIColor.clear.cgColor
        text.layer.borderWidth = 0.0
        text.attributedPlaceholder = "2022".placeholder
        text.tintColor = .clear
        return text
    }()
    
    private(set) lazy var monthText: Textfield = {
        let text = Textfield()
        text.rightImage = .rightArrow
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .textBackground
        text.layer.borderColor = UIColor.clear.cgColor
        text.layer.borderWidth = 0.0
        text.attributedPlaceholder = "12".placeholder
        text.tintColor = .clear
        return text
    }()
    
    private(set) lazy var dayText: Textfield = {
        let text = Textfield()
        text.rightImage = .rightArrow
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .textBackground
        text.layer.borderColor = UIColor.clear.cgColor
        text.layer.borderWidth = 0.0
        text.attributedPlaceholder = "12".placeholder
        text.tintColor = .clear
        return text
    }()
    
    private(set) lazy var occupationName: CustomText = {
        let view = CustomText()
        view.textfield.rightImage = .rightArrow
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text = LocalizedKey.occupation.value
        view.textfield.backgroundColor = .textBackground
        view.textfield.layer.borderColor = UIColor.clear.cgColor
        view.textfield.layer.borderWidth = 0.0
        view.textfield.attributedPlaceholder = "Student".placeholder
        view.textfield.tintColor = .clear
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let scroll = UIStackView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.spacing = 26
        scroll.axis = .vertical
        return scroll
    }()
    
    private(set) lazy var emailAddress: CustomText = {
        let view = CustomText()
       // view.textfield.rightImage = .rightArrow
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text = LocalizedKey.emailAddress.value
        view.textfield.backgroundColor = .textBackground
        view.textfield.layer.borderColor = UIColor.clear.cgColor
        view.textfield.layer.borderWidth = 0.0
        view.textfield.attributedPlaceholder = "Student".placeholder
        view.isUserInteractionEnabled = false
        view.isHidden = true
        view.secureInfo.isHidden = true
        view.secureInfo.text = ""
        view.requiredInfo.text = ""
        view.requiredInfo.isHidden = true
        view.textfield.tintColor = .clear
        return view
    }()
    
    private lazy var selfIntroductionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.selfIntroduction.value
        label.textColor = .black
        label.font = .notoSansJPRegular(size: .size14)
        label.accessibilityIdentifier = "self"
        return label
    }()
    
    private(set) lazy var selfIntroductionText: TextView = {
        let view = TextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var toRegisterButton: AppButton = {
        let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.appButtonType = .auth
        button.setAttributedTitle(LocalizedKey.toRegister.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16)]), for: .normal)
        return button
    }()
    
    var selected =  GenderType.male {
        didSet {
            updateModeButton()
        }
    }
    
    override func create() {
        addSubview(scroll)
        scroll.addSubview(title)
        scroll.addSubview(image)
//        scroll.addSubview(profileDelButton)
        scroll.addSubview(imageButtonStackView)
        scroll.addSubview(fullName)
        scroll.addSubview(genderLabel)
        scroll.addSubview(requiredGenderInfo)
        scroll.addSubview(secureGenderInfo)
        scroll.addSubview(genderStack)
        genderStack.addArrangedSubview(genderSelectionStack)
        genderSelectionStack.addArrangedSubview(maleSelect)
        genderSelectionStack.addArrangedSubview(femaleSelect)
        genderSelectionStack.addArrangedSubview(otherSelect)
        genderStack.addArrangedSubview(genderOtherStack)
        genderOtherStack.addArrangedSubview(otherGenderText)
        genderOtherStack.addArrangedSubview(genderSaveButton)
        scroll.addSubview(nickName)
        scroll.addSubview(instrumentName)
        scroll.addSubview(postal)
        scroll.addSubview(ageLabel)
        scroll.addSubview(requiredAgeInfo)
        scroll.addSubview(ageStack)
        ageStack.addArrangedSubview(yearText)
        ageStack.addArrangedSubview(monthText)
        ageStack.addArrangedSubview(dayText)
        scroll.addSubview(stackView)
        stackView.addArrangedSubview(emailAddress)
        stackView.addArrangedSubview(occupationName)
        scroll.addSubview(selfIntroductionLabel)
        scroll.addSubview(selfIntroductionText)
        scroll.addSubview(toRegisterButton)
        super.create()
        
        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: cancelButton.topAnchor),
            scroll.widthAnchor.constraint(equalTo: widthAnchor),
            
            title.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            title.topAnchor.constraint(equalTo: scroll.topAnchor,  constant: 16),
            title.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
            image.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            image.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 140),
            image.heightAnchor.constraint(equalToConstant: 140),
        
//            profileDelButton.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: 0),
//            profileDelButton.centerXAnchor.constraint(equalTo: image.centerXAnchor, constant: 70),
//            profileDelButton.heightAnchor.constraint(equalToConstant: 40),
//            profileDelButton.widthAnchor.constraint(equalToConstant: 40),
    
//            imageButtonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21),
            imageButtonStackView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            imageButtonStackView.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
//            uploadIconButton.widthAnchor.constraint(equalToConstant: 142),
//            uploadIconButton.heightAnchor.constraint(equalToConstant: 30),
            
            fullName.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 21),
            fullName.topAnchor.constraint(equalTo: imageButtonStackView.bottomAnchor, constant: 47),
            fullName.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
            genderLabel.leadingAnchor.constraint(equalTo: fullName.leadingAnchor),
            genderLabel.topAnchor.constraint(equalTo: fullName.bottomAnchor, constant: 26),
            
            requiredGenderInfo.leadingAnchor.constraint(equalTo: genderLabel.trailingAnchor, constant: 11),
            requiredGenderInfo.topAnchor.constraint(equalTo: genderLabel.topAnchor),
            requiredGenderInfo.bottomAnchor.constraint(equalTo: genderLabel.bottomAnchor),
            
            secureGenderInfo.leadingAnchor.constraint(greaterThanOrEqualTo: requiredGenderInfo.trailingAnchor,  constant: 8),
            secureGenderInfo.topAnchor.constraint(equalTo: genderLabel.topAnchor),
            secureGenderInfo.trailingAnchor.constraint(equalTo: fullName.trailingAnchor),
            secureGenderInfo.bottomAnchor.constraint(equalTo: genderLabel.bottomAnchor),
            
            genderStack.leadingAnchor.constraint(equalTo: fullName.leadingAnchor),
            genderStack.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 12),
            genderStack.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
            genderOtherStack.heightAnchor.constraint(equalToConstant: 40),
            genderSelectionStack.heightAnchor.constraint(equalToConstant: 40),
           
            genderSaveButton.widthAnchor.constraint(equalToConstant: 104),
            
            nickName.leadingAnchor.constraint(equalTo: fullName.leadingAnchor),
            nickName.topAnchor.constraint(equalTo: genderStack.bottomAnchor, constant: 26),
            nickName.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
            instrumentName.leadingAnchor.constraint(equalTo: fullName.leadingAnchor),
            instrumentName.topAnchor.constraint(equalTo: nickName.bottomAnchor, constant: 26),
            instrumentName.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
            postal.leadingAnchor.constraint(equalTo: fullName.leadingAnchor),
            postal.topAnchor.constraint(equalTo: instrumentName.bottomAnchor, constant: 26),
            postal.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
            ageLabel.leadingAnchor.constraint(equalTo: fullName.leadingAnchor),
            ageLabel.topAnchor.constraint(equalTo: postal.bottomAnchor, constant: 26),
            
            requiredAgeInfo.leadingAnchor.constraint(equalTo: ageLabel.trailingAnchor, constant: 11),
            requiredAgeInfo.trailingAnchor.constraint(equalTo: fullName.trailingAnchor),
            requiredAgeInfo.topAnchor.constraint(equalTo: ageLabel.topAnchor),
            requiredAgeInfo.bottomAnchor.constraint(equalTo: ageLabel.bottomAnchor),
            
            ageStack.leadingAnchor.constraint(equalTo: ageLabel.leadingAnchor),
            ageStack.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            ageStack.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 8),
            ageStack.heightAnchor.constraint(equalToConstant: 50),
            
            monthText.widthAnchor.constraint(equalToConstant: 95),
            dayText.widthAnchor.constraint(equalToConstant: 95),
            
            stackView.leadingAnchor.constraint(equalTo: fullName.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: ageStack.bottomAnchor, constant: 26),
            stackView.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
//            emailAddress.leadingAnchor.constraint(equalTo: fullName.leadingAnchor),
//            emailAddress.topAnchor.constraint(equalTo: ageStack.bottomAnchor, constant: 26),
//            emailAddress.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
//
//            occupationName.leadingAnchor.constraint(equalTo: emailAddress.leadingAnchor),
//            occupationName.topAnchor.constraint(equalTo: emailAddress.bottomAnchor, constant: 26),
//            occupationName.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),

            
            selfIntroductionLabel.leadingAnchor.constraint(equalTo: fullName.leadingAnchor),
            selfIntroductionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 26),
            selfIntroductionLabel.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
            selfIntroductionText.leadingAnchor.constraint(equalTo: fullName.leadingAnchor),
            selfIntroductionText.topAnchor.constraint(equalTo: selfIntroductionLabel.bottomAnchor, constant: 12),
            selfIntroductionText.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            selfIntroductionText.heightAnchor.constraint(equalToConstant: 200),
            
            toRegisterButton.topAnchor.constraint(equalTo: selfIntroductionText.bottomAnchor, constant: 26),
            toRegisterButton.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            toRegisterButton.heightAnchor.constraint(equalToConstant: 44),
            toRegisterButton.widthAnchor.constraint(equalToConstant: 200),
            toRegisterButton.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -24)
        ])
    }
    
    
    @objc private func action(_ sender: SelectGender) {
        guard let gender = GenderType(rawValue: sender.tag) else {  return }
        selected = gender
        updateModeButton()
    }
    
    private func updateModeButton() {
        maleSelect.isSelected = maleSelect.tag == selected.rawValue
        femaleSelect.isSelected = femaleSelect.tag == selected.rawValue
        otherSelect.isSelected = otherSelect.tag == selected.rawValue
        
        switch selected {
        case .male:
            genderOtherStack.isHidden = true
        case .female:
            genderOtherStack.isHidden = true
        case .addOther:
            genderOtherStack.isHidden = false
        }
    }
}
