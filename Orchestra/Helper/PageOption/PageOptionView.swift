//
//  PageOptionView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/04/2022.
//

import UIKit

class PageOptionCircularView: UIView {
    
    //MARK: Properties
    let option: OrchestraType
    
    //MARK: UI Properties
    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, label])
        stackView.isUserInteractionEnabled = true
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var thumbnailImageView: RoundedImageView = {
        let imageView = RoundedImageView(image: option.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 90).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = option.title
        label.font = .boldItalicFont
//        label.font = .appFont(type: .notoSansJP(.bold), size: .size14)
        label.textColor = UIColor(hexString: "#888888")
        return label
    }()
    
    //MARK: Initializers
    init(option: OrchestraType) {
        self.option = option
        super.init(frame: .zero)
        prepareLayout()
    }
    
    override init(frame: CGRect) {
        self.option = .conductor
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    func prepareLayout() {
        addSubview(stackView)
        stackView.fillSuperView()
    }
    
}
