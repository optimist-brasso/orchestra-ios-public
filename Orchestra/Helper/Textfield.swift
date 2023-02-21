//
//  Textfield.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import UIKit
import Combine

class Textfield : UITextField {
    
    var rightImage: UIImage? {
        didSet {
            updateRightImage()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        create()
        tintColor = .black
    }
    
    /// Coder initializer
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        create()
        tintColor = .black
    }
    
    func create() {
        let left = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        left.backgroundColor = .red
        left.accessibilityIdentifier = "left"
        leftView = left
        
        leftViewMode = .always
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
    }
    
    func updateRightImage() {
        guard let rightImage = rightImage else {
            rightView = nil
            return
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.contentMode = .top
        view.addSubview(imageView)
        imageView.contentMode = .center
        imageView.image = rightImage
        rightView = view
        rightViewMode = .always
        rightView?.isUserInteractionEnabled = true
        rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightViewTapped)))
    }
    
    @objc func rightViewTapped() {
        self.becomeFirstResponder()
    }
    
}

class PasswordTextField: Textfield {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updatePasswordTextfield()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updatePasswordTextfield()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updatePasswordTextfield()
    }
    
    func updatePasswordTextfield() {
        self.rightView?.isUserInteractionEnabled = true
        self.rightView?.contentMode = .top
        isSecureTextEntry = true
        rightImage = UIImage.init(systemName: "eye.fill")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.rightViewTapped))
        self.rightView?.addGestureRecognizer(tap)
        rightImage?.setTemplate().withTintColor(.darkGray)
        rightView?.tintColor = .darkGray
    }
    
    @objc override func rightViewTapped() {
        self.isSecureTextEntry.toggle()
        self.rightImage =  self.isSecureTextEntry ? UIImage.init(systemName: "eye.fill") : UIImage.init(systemName: "eye.slash.fill")
        rightImage?.setTemplate().withTintColor(.darkGray)
        rightView?.tintColor = .darkGray
    }
    
}

class CustomText: UIView {
    private(set) lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.fullName.value
        label.textColor = .black
        label.font = .notoSansJPRegular(size: .size14)
        label.numberOfLines = 2
        return label
    }()
    
    private(set) lazy var secureInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.informationNotPublish.value
        label.textColor = .black
        label.numberOfLines = 2 
        label.font = .notoSansJPLight(size: .size12)
        return label
    }()
    
    private(set) lazy var requiredInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.requiredString.value
        label.textColor = .red
        label.font = .notoSansJPRegular(size: .size12)
        label.numberOfLines = 1
        return label
    }()
    
    private(set) lazy var textfield: Textfield = {
        let textfield = Textfield()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.textAlignment = .left
        textfield.placeholder =  LocalizedKey.pleaseEnterYourEmailAddress.value
        textfield.layer.cornerRadius = 5
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.black.cgColor
        textfield.layer.masksToBounds = true
        textfield.font = .notoSansJPRegular(size: .size14)
        return textfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createLayout()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createLayout()
    }
    
    private func createLayout() {
        addSubview(title)
        addSubview(requiredInfo)
        addSubview(secureInfo)
        addSubview(textfield)
        
        title.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            
            requiredInfo.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 4),
            requiredInfo.topAnchor.constraint(equalTo: topAnchor),
            requiredInfo.widthAnchor.constraint(equalToConstant: 60),
            requiredInfo.bottomAnchor.constraint(equalTo: title.bottomAnchor),
            
            secureInfo.leadingAnchor.constraint(greaterThanOrEqualTo: requiredInfo.trailingAnchor, constant: 4),
            secureInfo.topAnchor.constraint(equalTo: topAnchor),
            secureInfo.trailingAnchor.constraint(equalTo: trailingAnchor),
            secureInfo.bottomAnchor.constraint(equalTo: title.bottomAnchor),
            
            textfield.leadingAnchor.constraint(equalTo: leadingAnchor),
            textfield.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            textfield.trailingAnchor.constraint(equalTo: trailingAnchor),
            textfield.heightAnchor.constraint(equalToConstant: 44.0),
            textfield.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
}
