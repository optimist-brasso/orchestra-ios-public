//
//  PlayerSocialInfoView.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//

import UIKit

class PlayerSocialInfoView: UIView {
    
    //MARK: Properies
    let title: String
    
    //MARK: UI Propeties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .top
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.text = title
        label.font = .appFont(type: .notoSansJP(.medium), size: .size14)
        return label
    }()
    
    private(set) lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = "google.com"
        label.font = .appFont(type: .notoSansJP(.light), size: .size14)
        label.numberOfLines = .zero
        label.isUserInteractionEnabled = true
        return label
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
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Other functions
    private func prepareLayout() {
        addSubview(stackView)
        stackView.fillSuperView()
    }
    
    func setValue(_ value: String?) {
        valueLabel.text = value
        isHidden = value?.isEmpty ?? true
    }
    
    func setValueAsLink(_ value: String?) {
        let text = value ?? ""
        let attributedString = NSMutableAttributedString(string: value ?? "")
        let linkRange = NSRange(location: .zero, length: text.count)
        attributedString.addAttribute(.link, value: text, range: linkRange)
        valueLabel.attributedText = attributedString
        isHidden = value?.isEmpty ?? true
    }
    
}
